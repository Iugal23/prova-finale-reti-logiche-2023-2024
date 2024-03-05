-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 579;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,22,0,37,0,77,0,183,0,0,0,0,0,0,0,236,0,192,0,0,0,0,0,185,0,163,0,208,0,104,0,185,0,104,0,0,0,94,0,84,0,0,0,22,0,0,0,0,0,0,0,233,0,199,0,228,0,200,0,24,0,62,0,113,0,0,0,120,0,82,0,95,0,235,0,33,0,43,0,0,0,200,0,0,0,150,0,247,0,127,0,158,0,0,0,172,0,0,0,23,0,0,0,173,0,166,0,214,0,226,0,121,0,100,0,0,0,109,0,123,0,111,0,0,0,173,0,148,0,76,0,87,0,233,0,0,0,0,0,0,0,71,0,86,0,157,0,191,0,65,0,116,0,236,0,37,0,167,0,65,0,186,0,225,0,133,0,175,0,207,0,0,0,0,0,194,0,234,0,248,0,0,0,228,0,0,0,192,0,37,0,39,0,212,0,142,0,178,0,0,0,96,0,0,0,163,0,111,0,94,0,217,0,26,0,255,0,225,0,229,0,0,0,255,0,0,0,81,0,4,0,77,0,28,0,236,0,148,0,59,0,0,0,231,0,0,0,0,0,107,0,246,0,76,0,3,0,56,0,76,0,0,0,124,0,225,0,12,0,249,0,131,0,51,0,136,0,174,0,147,0,39,0,0,0,236,0,24,0,6,0,0,0,9,0,235,0,43,0,134,0,159,0,13,0,67,0,14,0,206,0,54,0,172,0,146,0,118,0,156,0,31,0,146,0,66,0,252,0,181,0,52,0,103,0,192,0,130,0,155,0,106,0,58,0,227,0,231,0,111,0,191,0,12,0,0,0,155,0,208,0,96,0,181,0,58,0,16,0,54,0,52,0,246,0,118,0,121,0,0,0,32,0,0,0,0,0,55,0,41,0,122,0,0,0,156,0,0,0,109,0,175,0,245,0,129,0,58,0,167,0,30,0,191,0,188,0,62,0,148,0,43,0,0,0,0,0,0,0,96,0,0,0,111,0,201,0,56,0,81,0,171,0,114,0,18,0,0,0,148,0,161,0,176,0,0,0,59,0,58,0,79,0,0,0,170,0,106,0,217,0,0,0,108,0,82,0,7,0,49,0,59,0,10,0,97,0,28,0,213,0,0,0,61,0,122,0,0,0,97,0,15,0,0,0,238,0,206,0,114,0,0,0,0,0,144,0,206,0,67,0,210,0,7,0,97,0,0,0,209,0,0,0,0,0,49,0,216,0,79,0,184,0,0,0,67,0,20,0,91,0,0,0,72,0,184,0,181,0,99,0,56,0,89,0,231,0,141,0,171,0,199,0,18,0,0,0,141,0,0,0,72,0,0,0,211,0,139,0,147,0,0,0,180,0,236,0,166,0,197,0,248,0,211,0,141,0,15,0,147,0,112,0,95,0,0,0,13,0,179,0,71,0,0,0,231,0,44,0,39,0,41,0,163,0,45,0,36,0,0,0,174,0,227,0,0,0,0,0,0,0,166,0,28,0,75,0,0,0,105,0,213,0,152,0,168,0,111,0,84,0,120,0,204,0,0,0,176,0,74,0,159,0,0,0,0,0,85,0,134,0,71,0,20,0,35,0,153,0,0,0,37,0,98,0,28,0,203,0,100,0,173,0,0,0,252,0,0,0,176,0,6,0,0,0,36,0,245,0,99,0,0,0,254,0,239,0,17,0,0,0,89,0,134,0,32,0,72,0,129,0,243,0,0,0,0,0,53,0,110,0,0,0,5,0,108,0,144,0,30,0,41,0,167,0,114,0,116,0,173,0,116,0,0,0,0,0,129,0,4,0,127,0,199,0,246,0,36,0,12,0,144,0,0,0,0,0,69,0,149,0,37,0,244,0,141,0,0,0,178,0,114,0,31,0,250,0,0,0,73,0,0,0,206,0,0,0,110,0,79,0,0,0,0,0,228,0,10,0,232,0,14,0,0,0,0,0,81,0,248,0,0,0,41,0,215,0,0,0,165,0,163,0,193,0,31,0,171,0,208,0,41,0,214,0,99,0,0,0,234,0,4,0,235,0,0,0,58,0,245,0,0,0,0,0,247,0,187,0,169,0,71,0,191,0,135,0,106,0,41,0,207,0,166,0,1,0,0,0,224,0,68,0,0,0,50,0,0,0,33,0,0,0,96,0,0,0,61,0,219,0,64,0,28,0,94,0,141,0,0,0,215,0,0,0,71,0,177,0,149,0,53,0,183,0,154,0,221,0,67,0,0,0,212,0,205,0,225,0,79,0,138,0,59,0,0,0,252,0,0,0,0,0,0,0,69,0,145,0,0,0,101,0,84,0,32,0,174,0,25,0,172,0,45,0,125,0,249,0,120,0,28,0,244,0,240,0,0,0,11,0,78,0,23,0,233,0,120,0,0,0,110,0,95,0,141,0,32,0,153,0,184,0,0,0,92,0,0,0,0,0,17,0,0,0,44,0,187,0,168,0,135,0,0,0,23,0,107,0,216,0,0,0,55,0,155,0,78,0,218,0,129,0,80,0,195,0,14,0,62,0,138,0,234,0,216,0,165,0,36,0,181,0,0,0,0,0,35,0,0,0,168,0,48,0,17,0,56,0,0,0,0,0,0,0,43,0,82,0,8,0,240,0,62,0,0,0);
signal scenario_full  : scenario_type := (0,0,22,31,37,31,77,31,183,31,183,30,183,29,183,28,236,31,192,31,192,30,192,29,185,31,163,31,208,31,104,31,185,31,104,31,104,30,94,31,84,31,84,30,22,31,22,30,22,29,22,28,233,31,199,31,228,31,200,31,24,31,62,31,113,31,113,30,120,31,82,31,95,31,235,31,33,31,43,31,43,30,200,31,200,30,150,31,247,31,127,31,158,31,158,30,172,31,172,30,23,31,23,30,173,31,166,31,214,31,226,31,121,31,100,31,100,30,109,31,123,31,111,31,111,30,173,31,148,31,76,31,87,31,233,31,233,30,233,29,233,28,71,31,86,31,157,31,191,31,65,31,116,31,236,31,37,31,167,31,65,31,186,31,225,31,133,31,175,31,207,31,207,30,207,29,194,31,234,31,248,31,248,30,228,31,228,30,192,31,37,31,39,31,212,31,142,31,178,31,178,30,96,31,96,30,163,31,111,31,94,31,217,31,26,31,255,31,225,31,229,31,229,30,255,31,255,30,81,31,4,31,77,31,28,31,236,31,148,31,59,31,59,30,231,31,231,30,231,29,107,31,246,31,76,31,3,31,56,31,76,31,76,30,124,31,225,31,12,31,249,31,131,31,51,31,136,31,174,31,147,31,39,31,39,30,236,31,24,31,6,31,6,30,9,31,235,31,43,31,134,31,159,31,13,31,67,31,14,31,206,31,54,31,172,31,146,31,118,31,156,31,31,31,146,31,66,31,252,31,181,31,52,31,103,31,192,31,130,31,155,31,106,31,58,31,227,31,231,31,111,31,191,31,12,31,12,30,155,31,208,31,96,31,181,31,58,31,16,31,54,31,52,31,246,31,118,31,121,31,121,30,32,31,32,30,32,29,55,31,41,31,122,31,122,30,156,31,156,30,109,31,175,31,245,31,129,31,58,31,167,31,30,31,191,31,188,31,62,31,148,31,43,31,43,30,43,29,43,28,96,31,96,30,111,31,201,31,56,31,81,31,171,31,114,31,18,31,18,30,148,31,161,31,176,31,176,30,59,31,58,31,79,31,79,30,170,31,106,31,217,31,217,30,108,31,82,31,7,31,49,31,59,31,10,31,97,31,28,31,213,31,213,30,61,31,122,31,122,30,97,31,15,31,15,30,238,31,206,31,114,31,114,30,114,29,144,31,206,31,67,31,210,31,7,31,97,31,97,30,209,31,209,30,209,29,49,31,216,31,79,31,184,31,184,30,67,31,20,31,91,31,91,30,72,31,184,31,181,31,99,31,56,31,89,31,231,31,141,31,171,31,199,31,18,31,18,30,141,31,141,30,72,31,72,30,211,31,139,31,147,31,147,30,180,31,236,31,166,31,197,31,248,31,211,31,141,31,15,31,147,31,112,31,95,31,95,30,13,31,179,31,71,31,71,30,231,31,44,31,39,31,41,31,163,31,45,31,36,31,36,30,174,31,227,31,227,30,227,29,227,28,166,31,28,31,75,31,75,30,105,31,213,31,152,31,168,31,111,31,84,31,120,31,204,31,204,30,176,31,74,31,159,31,159,30,159,29,85,31,134,31,71,31,20,31,35,31,153,31,153,30,37,31,98,31,28,31,203,31,100,31,173,31,173,30,252,31,252,30,176,31,6,31,6,30,36,31,245,31,99,31,99,30,254,31,239,31,17,31,17,30,89,31,134,31,32,31,72,31,129,31,243,31,243,30,243,29,53,31,110,31,110,30,5,31,108,31,144,31,30,31,41,31,167,31,114,31,116,31,173,31,116,31,116,30,116,29,129,31,4,31,127,31,199,31,246,31,36,31,12,31,144,31,144,30,144,29,69,31,149,31,37,31,244,31,141,31,141,30,178,31,114,31,31,31,250,31,250,30,73,31,73,30,206,31,206,30,110,31,79,31,79,30,79,29,228,31,10,31,232,31,14,31,14,30,14,29,81,31,248,31,248,30,41,31,215,31,215,30,165,31,163,31,193,31,31,31,171,31,208,31,41,31,214,31,99,31,99,30,234,31,4,31,235,31,235,30,58,31,245,31,245,30,245,29,247,31,187,31,169,31,71,31,191,31,135,31,106,31,41,31,207,31,166,31,1,31,1,30,224,31,68,31,68,30,50,31,50,30,33,31,33,30,96,31,96,30,61,31,219,31,64,31,28,31,94,31,141,31,141,30,215,31,215,30,71,31,177,31,149,31,53,31,183,31,154,31,221,31,67,31,67,30,212,31,205,31,225,31,79,31,138,31,59,31,59,30,252,31,252,30,252,29,252,28,69,31,145,31,145,30,101,31,84,31,32,31,174,31,25,31,172,31,45,31,125,31,249,31,120,31,28,31,244,31,240,31,240,30,11,31,78,31,23,31,233,31,120,31,120,30,110,31,95,31,141,31,32,31,153,31,184,31,184,30,92,31,92,30,92,29,17,31,17,30,44,31,187,31,168,31,135,31,135,30,23,31,107,31,216,31,216,30,55,31,155,31,78,31,218,31,129,31,80,31,195,31,14,31,62,31,138,31,234,31,216,31,165,31,36,31,181,31,181,30,181,29,35,31,35,30,168,31,48,31,17,31,56,31,56,30,56,29,56,28,43,31,82,31,8,31,240,31,62,31,62,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;

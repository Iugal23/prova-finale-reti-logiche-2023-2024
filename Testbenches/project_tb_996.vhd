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

constant SCENARIO_LENGTH : integer := 440;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,186,0,219,0,52,0,228,0,227,0,109,0,0,0,195,0,28,0,149,0,229,0,94,0,18,0,207,0,123,0,100,0,170,0,230,0,201,0,24,0,187,0,78,0,222,0,161,0,73,0,86,0,214,0,0,0,221,0,117,0,241,0,129,0,70,0,114,0,0,0,216,0,64,0,121,0,110,0,79,0,0,0,25,0,193,0,58,0,48,0,0,0,241,0,152,0,213,0,134,0,0,0,200,0,82,0,20,0,199,0,207,0,181,0,78,0,197,0,0,0,244,0,0,0,143,0,0,0,107,0,230,0,69,0,0,0,194,0,1,0,167,0,251,0,105,0,22,0,54,0,201,0,0,0,99,0,6,0,228,0,0,0,58,0,107,0,100,0,224,0,0,0,70,0,0,0,221,0,191,0,166,0,38,0,92,0,35,0,127,0,202,0,101,0,42,0,158,0,80,0,107,0,83,0,246,0,132,0,192,0,123,0,0,0,62,0,155,0,208,0,13,0,171,0,109,0,229,0,52,0,64,0,53,0,107,0,0,0,96,0,235,0,155,0,124,0,107,0,55,0,0,0,102,0,58,0,0,0,24,0,96,0,177,0,85,0,205,0,200,0,79,0,16,0,199,0,15,0,0,0,174,0,31,0,29,0,0,0,235,0,0,0,117,0,219,0,0,0,118,0,0,0,255,0,0,0,250,0,27,0,43,0,79,0,161,0,36,0,0,0,0,0,255,0,0,0,41,0,199,0,241,0,206,0,229,0,163,0,0,0,130,0,0,0,179,0,110,0,143,0,245,0,249,0,61,0,22,0,0,0,85,0,96,0,181,0,57,0,81,0,116,0,150,0,0,0,26,0,162,0,244,0,147,0,195,0,0,0,0,0,106,0,27,0,0,0,41,0,207,0,123,0,233,0,118,0,128,0,135,0,226,0,157,0,141,0,0,0,120,0,144,0,106,0,192,0,115,0,26,0,194,0,133,0,105,0,9,0,89,0,39,0,75,0,16,0,139,0,220,0,116,0,200,0,205,0,48,0,99,0,214,0,109,0,41,0,23,0,201,0,0,0,133,0,159,0,57,0,60,0,132,0,0,0,137,0,130,0,148,0,206,0,0,0,121,0,4,0,174,0,120,0,6,0,124,0,65,0,54,0,19,0,95,0,0,0,242,0,41,0,50,0,91,0,182,0,196,0,110,0,158,0,63,0,205,0,94,0,109,0,184,0,0,0,191,0,172,0,135,0,169,0,0,0,149,0,25,0,67,0,88,0,254,0,56,0,0,0,4,0,0,0,0,0,239,0,212,0,4,0,105,0,82,0,32,0,0,0,22,0,113,0,212,0,0,0,76,0,0,0,238,0,153,0,13,0,62,0,85,0,66,0,20,0,179,0,51,0,59,0,218,0,189,0,198,0,203,0,91,0,156,0,232,0,31,0,228,0,221,0,136,0,123,0,0,0,251,0,43,0,60,0,0,0,231,0,0,0,84,0,232,0,191,0,183,0,32,0,221,0,79,0,0,0,192,0,17,0,15,0,118,0,0,0,66,0,125,0,93,0,160,0,40,0,65,0,198,0,168,0,104,0,0,0,56,0,207,0,158,0,0,0,0,0,0,0,0,0,248,0,33,0,206,0,0,0,175,0,182,0,141,0,247,0,0,0,3,0,7,0,248,0,97,0,0,0,108,0,158,0,156,0,0,0,226,0,123,0,3,0,0,0,255,0,50,0,138,0,132,0,0,0,60,0,157,0,31,0,181,0,161,0,121,0,189,0,108,0,159,0,0,0,131,0,167,0,14,0,0,0,203,0,221,0,191,0,80,0,174,0,167,0,182,0,174,0,178,0,181,0,113,0,39,0,0,0,72,0,84,0,0,0,109,0,249,0,148,0,183,0,221,0,22,0,143,0,12,0,103,0,16,0,191,0,134,0,0,0,49,0,112,0,0,0,178,0,0,0,227,0,60,0,52,0,105,0,0,0);
signal scenario_full  : scenario_type := (0,0,186,31,219,31,52,31,228,31,227,31,109,31,109,30,195,31,28,31,149,31,229,31,94,31,18,31,207,31,123,31,100,31,170,31,230,31,201,31,24,31,187,31,78,31,222,31,161,31,73,31,86,31,214,31,214,30,221,31,117,31,241,31,129,31,70,31,114,31,114,30,216,31,64,31,121,31,110,31,79,31,79,30,25,31,193,31,58,31,48,31,48,30,241,31,152,31,213,31,134,31,134,30,200,31,82,31,20,31,199,31,207,31,181,31,78,31,197,31,197,30,244,31,244,30,143,31,143,30,107,31,230,31,69,31,69,30,194,31,1,31,167,31,251,31,105,31,22,31,54,31,201,31,201,30,99,31,6,31,228,31,228,30,58,31,107,31,100,31,224,31,224,30,70,31,70,30,221,31,191,31,166,31,38,31,92,31,35,31,127,31,202,31,101,31,42,31,158,31,80,31,107,31,83,31,246,31,132,31,192,31,123,31,123,30,62,31,155,31,208,31,13,31,171,31,109,31,229,31,52,31,64,31,53,31,107,31,107,30,96,31,235,31,155,31,124,31,107,31,55,31,55,30,102,31,58,31,58,30,24,31,96,31,177,31,85,31,205,31,200,31,79,31,16,31,199,31,15,31,15,30,174,31,31,31,29,31,29,30,235,31,235,30,117,31,219,31,219,30,118,31,118,30,255,31,255,30,250,31,27,31,43,31,79,31,161,31,36,31,36,30,36,29,255,31,255,30,41,31,199,31,241,31,206,31,229,31,163,31,163,30,130,31,130,30,179,31,110,31,143,31,245,31,249,31,61,31,22,31,22,30,85,31,96,31,181,31,57,31,81,31,116,31,150,31,150,30,26,31,162,31,244,31,147,31,195,31,195,30,195,29,106,31,27,31,27,30,41,31,207,31,123,31,233,31,118,31,128,31,135,31,226,31,157,31,141,31,141,30,120,31,144,31,106,31,192,31,115,31,26,31,194,31,133,31,105,31,9,31,89,31,39,31,75,31,16,31,139,31,220,31,116,31,200,31,205,31,48,31,99,31,214,31,109,31,41,31,23,31,201,31,201,30,133,31,159,31,57,31,60,31,132,31,132,30,137,31,130,31,148,31,206,31,206,30,121,31,4,31,174,31,120,31,6,31,124,31,65,31,54,31,19,31,95,31,95,30,242,31,41,31,50,31,91,31,182,31,196,31,110,31,158,31,63,31,205,31,94,31,109,31,184,31,184,30,191,31,172,31,135,31,169,31,169,30,149,31,25,31,67,31,88,31,254,31,56,31,56,30,4,31,4,30,4,29,239,31,212,31,4,31,105,31,82,31,32,31,32,30,22,31,113,31,212,31,212,30,76,31,76,30,238,31,153,31,13,31,62,31,85,31,66,31,20,31,179,31,51,31,59,31,218,31,189,31,198,31,203,31,91,31,156,31,232,31,31,31,228,31,221,31,136,31,123,31,123,30,251,31,43,31,60,31,60,30,231,31,231,30,84,31,232,31,191,31,183,31,32,31,221,31,79,31,79,30,192,31,17,31,15,31,118,31,118,30,66,31,125,31,93,31,160,31,40,31,65,31,198,31,168,31,104,31,104,30,56,31,207,31,158,31,158,30,158,29,158,28,158,27,248,31,33,31,206,31,206,30,175,31,182,31,141,31,247,31,247,30,3,31,7,31,248,31,97,31,97,30,108,31,158,31,156,31,156,30,226,31,123,31,3,31,3,30,255,31,50,31,138,31,132,31,132,30,60,31,157,31,31,31,181,31,161,31,121,31,189,31,108,31,159,31,159,30,131,31,167,31,14,31,14,30,203,31,221,31,191,31,80,31,174,31,167,31,182,31,174,31,178,31,181,31,113,31,39,31,39,30,72,31,84,31,84,30,109,31,249,31,148,31,183,31,221,31,22,31,143,31,12,31,103,31,16,31,191,31,134,31,134,30,49,31,112,31,112,30,178,31,178,30,227,31,60,31,52,31,105,31,105,30);

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

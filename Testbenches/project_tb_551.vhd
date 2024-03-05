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

constant SCENARIO_LENGTH : integer := 564;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (215,0,106,0,164,0,26,0,0,0,84,0,208,0,60,0,196,0,69,0,218,0,68,0,63,0,0,0,75,0,144,0,0,0,115,0,181,0,48,0,15,0,77,0,74,0,106,0,229,0,0,0,36,0,140,0,35,0,87,0,85,0,0,0,0,0,120,0,205,0,146,0,178,0,186,0,187,0,0,0,99,0,0,0,180,0,171,0,0,0,32,0,180,0,75,0,32,0,54,0,135,0,195,0,140,0,15,0,181,0,36,0,41,0,77,0,96,0,154,0,37,0,0,0,240,0,177,0,0,0,177,0,0,0,48,0,25,0,179,0,0,0,238,0,17,0,248,0,0,0,0,0,134,0,199,0,0,0,173,0,202,0,3,0,238,0,139,0,23,0,0,0,0,0,210,0,192,0,83,0,35,0,85,0,4,0,180,0,33,0,0,0,157,0,99,0,104,0,0,0,173,0,169,0,0,0,140,0,239,0,79,0,0,0,121,0,147,0,110,0,166,0,125,0,63,0,121,0,0,0,147,0,3,0,96,0,172,0,0,0,70,0,128,0,41,0,232,0,0,0,0,0,21,0,220,0,57,0,167,0,222,0,150,0,92,0,150,0,87,0,76,0,0,0,241,0,193,0,112,0,224,0,134,0,87,0,0,0,14,0,0,0,89,0,214,0,38,0,0,0,0,0,210,0,164,0,87,0,121,0,185,0,118,0,0,0,125,0,213,0,111,0,107,0,137,0,141,0,81,0,122,0,0,0,29,0,109,0,44,0,207,0,188,0,140,0,17,0,7,0,0,0,0,0,148,0,98,0,221,0,0,0,12,0,106,0,0,0,249,0,37,0,227,0,225,0,145,0,0,0,22,0,0,0,185,0,58,0,0,0,20,0,29,0,23,0,209,0,216,0,159,0,68,0,115,0,8,0,92,0,226,0,0,0,41,0,232,0,132,0,4,0,155,0,129,0,0,0,221,0,55,0,26,0,0,0,108,0,13,0,0,0,53,0,58,0,0,0,208,0,68,0,125,0,177,0,249,0,181,0,243,0,212,0,190,0,142,0,86,0,247,0,76,0,232,0,102,0,123,0,197,0,0,0,59,0,193,0,239,0,9,0,140,0,88,0,0,0,126,0,253,0,245,0,149,0,0,0,210,0,56,0,0,0,54,0,0,0,152,0,68,0,178,0,203,0,0,0,230,0,222,0,222,0,110,0,220,0,0,0,0,0,101,0,26,0,96,0,0,0,38,0,66,0,244,0,5,0,232,0,234,0,61,0,12,0,38,0,0,0,0,0,174,0,89,0,223,0,208,0,197,0,0,0,83,0,8,0,0,0,213,0,192,0,120,0,0,0,209,0,36,0,226,0,221,0,0,0,196,0,67,0,235,0,202,0,36,0,77,0,99,0,0,0,67,0,116,0,206,0,238,0,0,0,183,0,252,0,2,0,0,0,222,0,0,0,150,0,108,0,46,0,249,0,41,0,218,0,190,0,125,0,156,0,0,0,0,0,228,0,151,0,125,0,242,0,0,0,158,0,0,0,0,0,86,0,240,0,195,0,164,0,112,0,0,0,175,0,0,0,0,0,91,0,178,0,216,0,42,0,210,0,98,0,0,0,213,0,146,0,21,0,104,0,2,0,67,0,48,0,82,0,108,0,31,0,34,0,46,0,174,0,135,0,0,0,125,0,175,0,0,0,0,0,88,0,72,0,0,0,138,0,27,0,136,0,18,0,184,0,54,0,9,0,182,0,100,0,100,0,100,0,206,0,221,0,101,0,16,0,60,0,193,0,169,0,103,0,110,0,23,0,0,0,78,0,0,0,103,0,0,0,233,0,185,0,0,0,79,0,28,0,192,0,129,0,66,0,0,0,90,0,250,0,0,0,158,0,96,0,174,0,118,0,150,0,245,0,78,0,9,0,157,0,28,0,242,0,199,0,159,0,141,0,248,0,215,0,6,0,247,0,175,0,62,0,132,0,83,0,115,0,243,0,0,0,226,0,0,0,191,0,246,0,0,0,209,0,0,0,54,0,0,0,191,0,28,0,0,0,133,0,0,0,92,0,94,0,128,0,4,0,183,0,152,0,55,0,227,0,214,0,132,0,166,0,0,0,133,0,128,0,9,0,184,0,241,0,12,0,0,0,82,0,31,0,29,0,105,0,130,0,67,0,141,0,239,0,36,0,15,0,147,0,98,0,128,0,237,0,73,0,0,0,0,0,196,0,157,0,184,0,223,0,0,0,243,0,156,0,246,0,240,0,0,0,151,0,0,0,0,0,95,0,177,0,17,0,88,0,0,0,200,0,233,0,0,0,211,0,186,0,153,0,224,0,106,0,25,0,0,0,76,0,210,0,165,0,18,0,21,0,0,0,240,0,182,0,189,0,148,0,88,0,154,0,207,0,66,0,219,0,162,0,93,0,28,0,211,0,153,0,229,0,224,0,72,0,89,0,58,0,54,0,101,0,136,0,0,0,0,0,163,0,225,0,153,0,114,0,180,0,155,0,0,0,174,0,151,0,0,0,10,0,29,0,27,0);
signal scenario_full  : scenario_type := (215,31,106,31,164,31,26,31,26,30,84,31,208,31,60,31,196,31,69,31,218,31,68,31,63,31,63,30,75,31,144,31,144,30,115,31,181,31,48,31,15,31,77,31,74,31,106,31,229,31,229,30,36,31,140,31,35,31,87,31,85,31,85,30,85,29,120,31,205,31,146,31,178,31,186,31,187,31,187,30,99,31,99,30,180,31,171,31,171,30,32,31,180,31,75,31,32,31,54,31,135,31,195,31,140,31,15,31,181,31,36,31,41,31,77,31,96,31,154,31,37,31,37,30,240,31,177,31,177,30,177,31,177,30,48,31,25,31,179,31,179,30,238,31,17,31,248,31,248,30,248,29,134,31,199,31,199,30,173,31,202,31,3,31,238,31,139,31,23,31,23,30,23,29,210,31,192,31,83,31,35,31,85,31,4,31,180,31,33,31,33,30,157,31,99,31,104,31,104,30,173,31,169,31,169,30,140,31,239,31,79,31,79,30,121,31,147,31,110,31,166,31,125,31,63,31,121,31,121,30,147,31,3,31,96,31,172,31,172,30,70,31,128,31,41,31,232,31,232,30,232,29,21,31,220,31,57,31,167,31,222,31,150,31,92,31,150,31,87,31,76,31,76,30,241,31,193,31,112,31,224,31,134,31,87,31,87,30,14,31,14,30,89,31,214,31,38,31,38,30,38,29,210,31,164,31,87,31,121,31,185,31,118,31,118,30,125,31,213,31,111,31,107,31,137,31,141,31,81,31,122,31,122,30,29,31,109,31,44,31,207,31,188,31,140,31,17,31,7,31,7,30,7,29,148,31,98,31,221,31,221,30,12,31,106,31,106,30,249,31,37,31,227,31,225,31,145,31,145,30,22,31,22,30,185,31,58,31,58,30,20,31,29,31,23,31,209,31,216,31,159,31,68,31,115,31,8,31,92,31,226,31,226,30,41,31,232,31,132,31,4,31,155,31,129,31,129,30,221,31,55,31,26,31,26,30,108,31,13,31,13,30,53,31,58,31,58,30,208,31,68,31,125,31,177,31,249,31,181,31,243,31,212,31,190,31,142,31,86,31,247,31,76,31,232,31,102,31,123,31,197,31,197,30,59,31,193,31,239,31,9,31,140,31,88,31,88,30,126,31,253,31,245,31,149,31,149,30,210,31,56,31,56,30,54,31,54,30,152,31,68,31,178,31,203,31,203,30,230,31,222,31,222,31,110,31,220,31,220,30,220,29,101,31,26,31,96,31,96,30,38,31,66,31,244,31,5,31,232,31,234,31,61,31,12,31,38,31,38,30,38,29,174,31,89,31,223,31,208,31,197,31,197,30,83,31,8,31,8,30,213,31,192,31,120,31,120,30,209,31,36,31,226,31,221,31,221,30,196,31,67,31,235,31,202,31,36,31,77,31,99,31,99,30,67,31,116,31,206,31,238,31,238,30,183,31,252,31,2,31,2,30,222,31,222,30,150,31,108,31,46,31,249,31,41,31,218,31,190,31,125,31,156,31,156,30,156,29,228,31,151,31,125,31,242,31,242,30,158,31,158,30,158,29,86,31,240,31,195,31,164,31,112,31,112,30,175,31,175,30,175,29,91,31,178,31,216,31,42,31,210,31,98,31,98,30,213,31,146,31,21,31,104,31,2,31,67,31,48,31,82,31,108,31,31,31,34,31,46,31,174,31,135,31,135,30,125,31,175,31,175,30,175,29,88,31,72,31,72,30,138,31,27,31,136,31,18,31,184,31,54,31,9,31,182,31,100,31,100,31,100,31,206,31,221,31,101,31,16,31,60,31,193,31,169,31,103,31,110,31,23,31,23,30,78,31,78,30,103,31,103,30,233,31,185,31,185,30,79,31,28,31,192,31,129,31,66,31,66,30,90,31,250,31,250,30,158,31,96,31,174,31,118,31,150,31,245,31,78,31,9,31,157,31,28,31,242,31,199,31,159,31,141,31,248,31,215,31,6,31,247,31,175,31,62,31,132,31,83,31,115,31,243,31,243,30,226,31,226,30,191,31,246,31,246,30,209,31,209,30,54,31,54,30,191,31,28,31,28,30,133,31,133,30,92,31,94,31,128,31,4,31,183,31,152,31,55,31,227,31,214,31,132,31,166,31,166,30,133,31,128,31,9,31,184,31,241,31,12,31,12,30,82,31,31,31,29,31,105,31,130,31,67,31,141,31,239,31,36,31,15,31,147,31,98,31,128,31,237,31,73,31,73,30,73,29,196,31,157,31,184,31,223,31,223,30,243,31,156,31,246,31,240,31,240,30,151,31,151,30,151,29,95,31,177,31,17,31,88,31,88,30,200,31,233,31,233,30,211,31,186,31,153,31,224,31,106,31,25,31,25,30,76,31,210,31,165,31,18,31,21,31,21,30,240,31,182,31,189,31,148,31,88,31,154,31,207,31,66,31,219,31,162,31,93,31,28,31,211,31,153,31,229,31,224,31,72,31,89,31,58,31,54,31,101,31,136,31,136,30,136,29,163,31,225,31,153,31,114,31,180,31,155,31,155,30,174,31,151,31,151,30,10,31,29,31,27,31);

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

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

constant SCENARIO_LENGTH : integer := 599;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,9,0,220,0,118,0,0,0,124,0,132,0,190,0,57,0,0,0,1,0,30,0,22,0,126,0,219,0,237,0,63,0,112,0,11,0,159,0,0,0,186,0,227,0,162,0,0,0,69,0,20,0,223,0,163,0,25,0,105,0,89,0,163,0,141,0,231,0,164,0,205,0,0,0,0,0,70,0,0,0,205,0,0,0,218,0,243,0,60,0,0,0,201,0,0,0,232,0,37,0,65,0,64,0,160,0,96,0,118,0,138,0,0,0,111,0,136,0,242,0,160,0,0,0,0,0,0,0,167,0,0,0,249,0,17,0,15,0,110,0,108,0,75,0,49,0,0,0,28,0,0,0,61,0,233,0,0,0,0,0,20,0,199,0,81,0,213,0,147,0,143,0,32,0,22,0,0,0,83,0,0,0,142,0,47,0,4,0,153,0,151,0,122,0,8,0,49,0,255,0,230,0,0,0,148,0,235,0,8,0,105,0,124,0,0,0,0,0,219,0,88,0,9,0,178,0,132,0,13,0,112,0,35,0,29,0,88,0,160,0,0,0,0,0,71,0,11,0,0,0,0,0,249,0,182,0,193,0,253,0,48,0,0,0,24,0,243,0,66,0,19,0,47,0,158,0,229,0,47,0,0,0,182,0,14,0,234,0,102,0,182,0,245,0,251,0,208,0,113,0,22,0,141,0,120,0,152,0,79,0,0,0,68,0,103,0,23,0,14,0,165,0,157,0,183,0,215,0,43,0,0,0,0,0,133,0,149,0,174,0,189,0,99,0,144,0,26,0,86,0,47,0,0,0,231,0,83,0,0,0,82,0,0,0,35,0,0,0,215,0,73,0,141,0,0,0,0,0,124,0,228,0,35,0,122,0,83,0,119,0,208,0,222,0,206,0,193,0,54,0,15,0,157,0,0,0,90,0,0,0,0,0,253,0,237,0,171,0,233,0,0,0,222,0,0,0,202,0,230,0,69,0,148,0,233,0,54,0,162,0,0,0,161,0,181,0,255,0,254,0,192,0,45,0,25,0,89,0,108,0,0,0,227,0,210,0,0,0,1,0,129,0,242,0,75,0,78,0,147,0,35,0,22,0,0,0,227,0,155,0,144,0,195,0,236,0,172,0,243,0,3,0,0,0,0,0,245,0,71,0,12,0,0,0,198,0,245,0,1,0,191,0,0,0,214,0,158,0,0,0,200,0,175,0,110,0,32,0,16,0,73,0,95,0,0,0,0,0,85,0,6,0,203,0,98,0,120,0,248,0,126,0,37,0,0,0,7,0,0,0,95,0,114,0,208,0,30,0,134,0,190,0,0,0,93,0,0,0,175,0,0,0,0,0,0,0,237,0,0,0,122,0,0,0,56,0,184,0,83,0,183,0,212,0,126,0,92,0,113,0,2,0,183,0,100,0,78,0,239,0,203,0,31,0,119,0,0,0,208,0,26,0,99,0,168,0,0,0,0,0,26,0,0,0,150,0,83,0,149,0,237,0,37,0,0,0,181,0,133,0,188,0,224,0,35,0,81,0,168,0,93,0,0,0,178,0,0,0,236,0,0,0,59,0,148,0,203,0,182,0,12,0,0,0,214,0,42,0,219,0,20,0,143,0,47,0,13,0,62,0,210,0,0,0,232,0,163,0,0,0,113,0,35,0,184,0,0,0,0,0,57,0,238,0,195,0,0,0,87,0,199,0,44,0,164,0,184,0,110,0,0,0,0,0,148,0,106,0,250,0,0,0,150,0,174,0,0,0,162,0,70,0,140,0,104,0,183,0,137,0,232,0,55,0,142,0,87,0,100,0,141,0,32,0,57,0,176,0,35,0,0,0,56,0,120,0,65,0,217,0,0,0,71,0,123,0,0,0,57,0,0,0,7,0,0,0,249,0,0,0,78,0,120,0,46,0,0,0,60,0,152,0,44,0,10,0,186,0,0,0,252,0,0,0,250,0,218,0,122,0,145,0,222,0,56,0,190,0,215,0,96,0,239,0,8,0,0,0,0,0,0,0,80,0,118,0,231,0,63,0,0,0,73,0,199,0,105,0,0,0,111,0,10,0,0,0,176,0,208,0,209,0,2,0,11,0,189,0,113,0,47,0,188,0,20,0,176,0,0,0,135,0,18,0,0,0,235,0,0,0,213,0,159,0,89,0,0,0,19,0,251,0,0,0,245,0,202,0,46,0,90,0,104,0,182,0,83,0,178,0,128,0,138,0,39,0,78,0,216,0,235,0,83,0,56,0,22,0,0,0,161,0,227,0,0,0,0,0,186,0,225,0,0,0,190,0,0,0,87,0,64,0,54,0,48,0,0,0,91,0,144,0,21,0,83,0,192,0,125,0,230,0,131,0,35,0,0,0,189,0,30,0,121,0,113,0,0,0,0,0,0,0,252,0,0,0,223,0,109,0,89,0,103,0,182,0,0,0,36,0,216,0,201,0,63,0,112,0,93,0,75,0,104,0,0,0,0,0,222,0,41,0,176,0,230,0,10,0,98,0,77,0,23,0,62,0,43,0,0,0,0,0,36,0,0,0,61,0,0,0,4,0,36,0,2,0,0,0,172,0,185,0,83,0,46,0,78,0,21,0,111,0,84,0,74,0,86,0,179,0,0,0,103,0,146,0,39,0,108,0,0,0,48,0,0,0,100,0,8,0,192,0,0,0,86,0,0,0,119,0,0,0,26,0,213,0);
signal scenario_full  : scenario_type := (0,0,9,31,220,31,118,31,118,30,124,31,132,31,190,31,57,31,57,30,1,31,30,31,22,31,126,31,219,31,237,31,63,31,112,31,11,31,159,31,159,30,186,31,227,31,162,31,162,30,69,31,20,31,223,31,163,31,25,31,105,31,89,31,163,31,141,31,231,31,164,31,205,31,205,30,205,29,70,31,70,30,205,31,205,30,218,31,243,31,60,31,60,30,201,31,201,30,232,31,37,31,65,31,64,31,160,31,96,31,118,31,138,31,138,30,111,31,136,31,242,31,160,31,160,30,160,29,160,28,167,31,167,30,249,31,17,31,15,31,110,31,108,31,75,31,49,31,49,30,28,31,28,30,61,31,233,31,233,30,233,29,20,31,199,31,81,31,213,31,147,31,143,31,32,31,22,31,22,30,83,31,83,30,142,31,47,31,4,31,153,31,151,31,122,31,8,31,49,31,255,31,230,31,230,30,148,31,235,31,8,31,105,31,124,31,124,30,124,29,219,31,88,31,9,31,178,31,132,31,13,31,112,31,35,31,29,31,88,31,160,31,160,30,160,29,71,31,11,31,11,30,11,29,249,31,182,31,193,31,253,31,48,31,48,30,24,31,243,31,66,31,19,31,47,31,158,31,229,31,47,31,47,30,182,31,14,31,234,31,102,31,182,31,245,31,251,31,208,31,113,31,22,31,141,31,120,31,152,31,79,31,79,30,68,31,103,31,23,31,14,31,165,31,157,31,183,31,215,31,43,31,43,30,43,29,133,31,149,31,174,31,189,31,99,31,144,31,26,31,86,31,47,31,47,30,231,31,83,31,83,30,82,31,82,30,35,31,35,30,215,31,73,31,141,31,141,30,141,29,124,31,228,31,35,31,122,31,83,31,119,31,208,31,222,31,206,31,193,31,54,31,15,31,157,31,157,30,90,31,90,30,90,29,253,31,237,31,171,31,233,31,233,30,222,31,222,30,202,31,230,31,69,31,148,31,233,31,54,31,162,31,162,30,161,31,181,31,255,31,254,31,192,31,45,31,25,31,89,31,108,31,108,30,227,31,210,31,210,30,1,31,129,31,242,31,75,31,78,31,147,31,35,31,22,31,22,30,227,31,155,31,144,31,195,31,236,31,172,31,243,31,3,31,3,30,3,29,245,31,71,31,12,31,12,30,198,31,245,31,1,31,191,31,191,30,214,31,158,31,158,30,200,31,175,31,110,31,32,31,16,31,73,31,95,31,95,30,95,29,85,31,6,31,203,31,98,31,120,31,248,31,126,31,37,31,37,30,7,31,7,30,95,31,114,31,208,31,30,31,134,31,190,31,190,30,93,31,93,30,175,31,175,30,175,29,175,28,237,31,237,30,122,31,122,30,56,31,184,31,83,31,183,31,212,31,126,31,92,31,113,31,2,31,183,31,100,31,78,31,239,31,203,31,31,31,119,31,119,30,208,31,26,31,99,31,168,31,168,30,168,29,26,31,26,30,150,31,83,31,149,31,237,31,37,31,37,30,181,31,133,31,188,31,224,31,35,31,81,31,168,31,93,31,93,30,178,31,178,30,236,31,236,30,59,31,148,31,203,31,182,31,12,31,12,30,214,31,42,31,219,31,20,31,143,31,47,31,13,31,62,31,210,31,210,30,232,31,163,31,163,30,113,31,35,31,184,31,184,30,184,29,57,31,238,31,195,31,195,30,87,31,199,31,44,31,164,31,184,31,110,31,110,30,110,29,148,31,106,31,250,31,250,30,150,31,174,31,174,30,162,31,70,31,140,31,104,31,183,31,137,31,232,31,55,31,142,31,87,31,100,31,141,31,32,31,57,31,176,31,35,31,35,30,56,31,120,31,65,31,217,31,217,30,71,31,123,31,123,30,57,31,57,30,7,31,7,30,249,31,249,30,78,31,120,31,46,31,46,30,60,31,152,31,44,31,10,31,186,31,186,30,252,31,252,30,250,31,218,31,122,31,145,31,222,31,56,31,190,31,215,31,96,31,239,31,8,31,8,30,8,29,8,28,80,31,118,31,231,31,63,31,63,30,73,31,199,31,105,31,105,30,111,31,10,31,10,30,176,31,208,31,209,31,2,31,11,31,189,31,113,31,47,31,188,31,20,31,176,31,176,30,135,31,18,31,18,30,235,31,235,30,213,31,159,31,89,31,89,30,19,31,251,31,251,30,245,31,202,31,46,31,90,31,104,31,182,31,83,31,178,31,128,31,138,31,39,31,78,31,216,31,235,31,83,31,56,31,22,31,22,30,161,31,227,31,227,30,227,29,186,31,225,31,225,30,190,31,190,30,87,31,64,31,54,31,48,31,48,30,91,31,144,31,21,31,83,31,192,31,125,31,230,31,131,31,35,31,35,30,189,31,30,31,121,31,113,31,113,30,113,29,113,28,252,31,252,30,223,31,109,31,89,31,103,31,182,31,182,30,36,31,216,31,201,31,63,31,112,31,93,31,75,31,104,31,104,30,104,29,222,31,41,31,176,31,230,31,10,31,98,31,77,31,23,31,62,31,43,31,43,30,43,29,36,31,36,30,61,31,61,30,4,31,36,31,2,31,2,30,172,31,185,31,83,31,46,31,78,31,21,31,111,31,84,31,74,31,86,31,179,31,179,30,103,31,146,31,39,31,108,31,108,30,48,31,48,30,100,31,8,31,192,31,192,30,86,31,86,30,119,31,119,30,26,31,213,31);

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

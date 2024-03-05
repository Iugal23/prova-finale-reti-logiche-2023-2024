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

constant SCENARIO_LENGTH : integer := 612;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (178,0,49,0,185,0,87,0,173,0,253,0,234,0,16,0,0,0,255,0,209,0,123,0,145,0,109,0,133,0,238,0,111,0,143,0,39,0,94,0,11,0,130,0,21,0,177,0,0,0,46,0,143,0,0,0,72,0,210,0,96,0,0,0,99,0,100,0,20,0,177,0,0,0,135,0,254,0,248,0,93,0,215,0,234,0,167,0,216,0,12,0,225,0,196,0,44,0,21,0,30,0,69,0,158,0,254,0,107,0,0,0,211,0,0,0,137,0,31,0,0,0,0,0,32,0,20,0,0,0,195,0,55,0,54,0,51,0,192,0,175,0,138,0,0,0,0,0,234,0,56,0,222,0,0,0,238,0,25,0,92,0,0,0,58,0,41,0,142,0,29,0,0,0,0,0,157,0,34,0,50,0,246,0,219,0,0,0,122,0,0,0,42,0,0,0,9,0,196,0,108,0,249,0,0,0,54,0,0,0,222,0,129,0,67,0,195,0,236,0,39,0,16,0,147,0,203,0,0,0,0,0,70,0,253,0,88,0,87,0,117,0,0,0,250,0,97,0,0,0,197,0,8,0,75,0,0,0,104,0,0,0,0,0,75,0,226,0,8,0,223,0,141,0,55,0,92,0,193,0,10,0,116,0,25,0,149,0,122,0,218,0,0,0,5,0,0,0,9,0,217,0,138,0,0,0,1,0,28,0,37,0,140,0,0,0,236,0,70,0,161,0,0,0,9,0,0,0,6,0,79,0,219,0,82,0,240,0,123,0,47,0,213,0,252,0,0,0,119,0,0,0,89,0,212,0,0,0,79,0,182,0,201,0,48,0,0,0,215,0,90,0,192,0,148,0,178,0,0,0,0,0,18,0,173,0,207,0,97,0,67,0,203,0,116,0,0,0,209,0,174,0,58,0,53,0,205,0,134,0,161,0,248,0,0,0,235,0,0,0,6,0,71,0,13,0,114,0,197,0,130,0,53,0,108,0,253,0,0,0,112,0,46,0,231,0,0,0,144,0,31,0,164,0,0,0,213,0,251,0,112,0,223,0,0,0,102,0,121,0,190,0,0,0,155,0,15,0,123,0,5,0,183,0,253,0,22,0,228,0,141,0,93,0,18,0,24,0,159,0,26,0,205,0,0,0,250,0,64,0,149,0,152,0,223,0,241,0,182,0,10,0,0,0,219,0,0,0,31,0,224,0,13,0,0,0,209,0,33,0,94,0,221,0,155,0,224,0,0,0,126,0,254,0,238,0,244,0,103,0,133,0,0,0,65,0,0,0,0,0,116,0,183,0,216,0,4,0,156,0,0,0,30,0,146,0,161,0,0,0,41,0,241,0,58,0,178,0,234,0,0,0,80,0,0,0,246,0,128,0,45,0,97,0,137,0,71,0,68,0,54,0,206,0,17,0,43,0,217,0,11,0,66,0,93,0,170,0,52,0,160,0,74,0,17,0,0,0,113,0,1,0,87,0,74,0,78,0,16,0,18,0,118,0,232,0,240,0,91,0,16,0,227,0,168,0,0,0,0,0,15,0,55,0,112,0,34,0,0,0,130,0,88,0,209,0,132,0,27,0,179,0,172,0,0,0,31,0,244,0,22,0,120,0,0,0,246,0,0,0,92,0,239,0,185,0,0,0,0,0,78,0,84,0,129,0,0,0,153,0,5,0,232,0,177,0,162,0,168,0,71,0,0,0,147,0,0,0,0,0,212,0,173,0,0,0,162,0,163,0,25,0,194,0,42,0,80,0,44,0,95,0,0,0,120,0,0,0,154,0,160,0,177,0,0,0,0,0,47,0,86,0,107,0,226,0,59,0,230,0,200,0,199,0,171,0,158,0,239,0,235,0,211,0,119,0,100,0,231,0,167,0,0,0,0,0,121,0,226,0,146,0,22,0,107,0,0,0,0,0,118,0,153,0,0,0,43,0,68,0,157,0,124,0,29,0,14,0,183,0,0,0,34,0,0,0,77,0,213,0,89,0,0,0,176,0,138,0,249,0,170,0,126,0,0,0,36,0,0,0,102,0,0,0,112,0,244,0,0,0,19,0,0,0,118,0,197,0,41,0,136,0,37,0,202,0,92,0,92,0,0,0,195,0,162,0,0,0,0,0,0,0,111,0,0,0,0,0,250,0,250,0,111,0,0,0,59,0,0,0,231,0,13,0,0,0,0,0,0,0,68,0,232,0,164,0,68,0,78,0,180,0,160,0,82,0,114,0,68,0,0,0,0,0,252,0,80,0,62,0,250,0,0,0,99,0,0,0,213,0,176,0,138,0,0,0,0,0,187,0,241,0,117,0,253,0,43,0,164,0,197,0,11,0,182,0,86,0,98,0,148,0,209,0,83,0,33,0,162,0,17,0,98,0,19,0,11,0,78,0,18,0,0,0,161,0,15,0,0,0,72,0,0,0,135,0,0,0,243,0,3,0,0,0,146,0,0,0,0,0,93,0,10,0,0,0,253,0,43,0,127,0,161,0,0,0,106,0,254,0,91,0,50,0,132,0,0,0,195,0,0,0,112,0,178,0,83,0,103,0,209,0,156,0,214,0,128,0,236,0,11,0,0,0,68,0,40,0,114,0,0,0,76,0,8,0,91,0,40,0,175,0,133,0,0,0,0,0,183,0,0,0,90,0,121,0,41,0,53,0,96,0,0,0,49,0,86,0,0,0,47,0,158,0,0,0,77,0,26,0,215,0,179,0,63,0,71,0,5,0,0,0,222,0,177,0,197,0,0,0,210,0,31,0);
signal scenario_full  : scenario_type := (178,31,49,31,185,31,87,31,173,31,253,31,234,31,16,31,16,30,255,31,209,31,123,31,145,31,109,31,133,31,238,31,111,31,143,31,39,31,94,31,11,31,130,31,21,31,177,31,177,30,46,31,143,31,143,30,72,31,210,31,96,31,96,30,99,31,100,31,20,31,177,31,177,30,135,31,254,31,248,31,93,31,215,31,234,31,167,31,216,31,12,31,225,31,196,31,44,31,21,31,30,31,69,31,158,31,254,31,107,31,107,30,211,31,211,30,137,31,31,31,31,30,31,29,32,31,20,31,20,30,195,31,55,31,54,31,51,31,192,31,175,31,138,31,138,30,138,29,234,31,56,31,222,31,222,30,238,31,25,31,92,31,92,30,58,31,41,31,142,31,29,31,29,30,29,29,157,31,34,31,50,31,246,31,219,31,219,30,122,31,122,30,42,31,42,30,9,31,196,31,108,31,249,31,249,30,54,31,54,30,222,31,129,31,67,31,195,31,236,31,39,31,16,31,147,31,203,31,203,30,203,29,70,31,253,31,88,31,87,31,117,31,117,30,250,31,97,31,97,30,197,31,8,31,75,31,75,30,104,31,104,30,104,29,75,31,226,31,8,31,223,31,141,31,55,31,92,31,193,31,10,31,116,31,25,31,149,31,122,31,218,31,218,30,5,31,5,30,9,31,217,31,138,31,138,30,1,31,28,31,37,31,140,31,140,30,236,31,70,31,161,31,161,30,9,31,9,30,6,31,79,31,219,31,82,31,240,31,123,31,47,31,213,31,252,31,252,30,119,31,119,30,89,31,212,31,212,30,79,31,182,31,201,31,48,31,48,30,215,31,90,31,192,31,148,31,178,31,178,30,178,29,18,31,173,31,207,31,97,31,67,31,203,31,116,31,116,30,209,31,174,31,58,31,53,31,205,31,134,31,161,31,248,31,248,30,235,31,235,30,6,31,71,31,13,31,114,31,197,31,130,31,53,31,108,31,253,31,253,30,112,31,46,31,231,31,231,30,144,31,31,31,164,31,164,30,213,31,251,31,112,31,223,31,223,30,102,31,121,31,190,31,190,30,155,31,15,31,123,31,5,31,183,31,253,31,22,31,228,31,141,31,93,31,18,31,24,31,159,31,26,31,205,31,205,30,250,31,64,31,149,31,152,31,223,31,241,31,182,31,10,31,10,30,219,31,219,30,31,31,224,31,13,31,13,30,209,31,33,31,94,31,221,31,155,31,224,31,224,30,126,31,254,31,238,31,244,31,103,31,133,31,133,30,65,31,65,30,65,29,116,31,183,31,216,31,4,31,156,31,156,30,30,31,146,31,161,31,161,30,41,31,241,31,58,31,178,31,234,31,234,30,80,31,80,30,246,31,128,31,45,31,97,31,137,31,71,31,68,31,54,31,206,31,17,31,43,31,217,31,11,31,66,31,93,31,170,31,52,31,160,31,74,31,17,31,17,30,113,31,1,31,87,31,74,31,78,31,16,31,18,31,118,31,232,31,240,31,91,31,16,31,227,31,168,31,168,30,168,29,15,31,55,31,112,31,34,31,34,30,130,31,88,31,209,31,132,31,27,31,179,31,172,31,172,30,31,31,244,31,22,31,120,31,120,30,246,31,246,30,92,31,239,31,185,31,185,30,185,29,78,31,84,31,129,31,129,30,153,31,5,31,232,31,177,31,162,31,168,31,71,31,71,30,147,31,147,30,147,29,212,31,173,31,173,30,162,31,163,31,25,31,194,31,42,31,80,31,44,31,95,31,95,30,120,31,120,30,154,31,160,31,177,31,177,30,177,29,47,31,86,31,107,31,226,31,59,31,230,31,200,31,199,31,171,31,158,31,239,31,235,31,211,31,119,31,100,31,231,31,167,31,167,30,167,29,121,31,226,31,146,31,22,31,107,31,107,30,107,29,118,31,153,31,153,30,43,31,68,31,157,31,124,31,29,31,14,31,183,31,183,30,34,31,34,30,77,31,213,31,89,31,89,30,176,31,138,31,249,31,170,31,126,31,126,30,36,31,36,30,102,31,102,30,112,31,244,31,244,30,19,31,19,30,118,31,197,31,41,31,136,31,37,31,202,31,92,31,92,31,92,30,195,31,162,31,162,30,162,29,162,28,111,31,111,30,111,29,250,31,250,31,111,31,111,30,59,31,59,30,231,31,13,31,13,30,13,29,13,28,68,31,232,31,164,31,68,31,78,31,180,31,160,31,82,31,114,31,68,31,68,30,68,29,252,31,80,31,62,31,250,31,250,30,99,31,99,30,213,31,176,31,138,31,138,30,138,29,187,31,241,31,117,31,253,31,43,31,164,31,197,31,11,31,182,31,86,31,98,31,148,31,209,31,83,31,33,31,162,31,17,31,98,31,19,31,11,31,78,31,18,31,18,30,161,31,15,31,15,30,72,31,72,30,135,31,135,30,243,31,3,31,3,30,146,31,146,30,146,29,93,31,10,31,10,30,253,31,43,31,127,31,161,31,161,30,106,31,254,31,91,31,50,31,132,31,132,30,195,31,195,30,112,31,178,31,83,31,103,31,209,31,156,31,214,31,128,31,236,31,11,31,11,30,68,31,40,31,114,31,114,30,76,31,8,31,91,31,40,31,175,31,133,31,133,30,133,29,183,31,183,30,90,31,121,31,41,31,53,31,96,31,96,30,49,31,86,31,86,30,47,31,158,31,158,30,77,31,26,31,215,31,179,31,63,31,71,31,5,31,5,30,222,31,177,31,197,31,197,30,210,31,31,31);

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

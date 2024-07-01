-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_873 is
end project_tb_873;

architecture project_tb_arch_873 of project_tb_873 is
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

constant SCENARIO_LENGTH : integer := 518;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (203,0,148,0,63,0,25,0,0,0,76,0,0,0,0,0,194,0,185,0,0,0,0,0,128,0,199,0,167,0,45,0,0,0,203,0,202,0,9,0,78,0,0,0,19,0,95,0,174,0,41,0,215,0,211,0,108,0,0,0,131,0,50,0,36,0,63,0,0,0,209,0,0,0,0,0,253,0,110,0,0,0,56,0,253,0,0,0,0,0,5,0,0,0,0,0,147,0,149,0,211,0,110,0,188,0,65,0,254,0,85,0,0,0,107,0,237,0,44,0,133,0,102,0,0,0,252,0,0,0,24,0,153,0,204,0,18,0,16,0,254,0,1,0,175,0,195,0,149,0,225,0,249,0,141,0,197,0,59,0,0,0,0,0,240,0,8,0,0,0,69,0,0,0,0,0,247,0,116,0,38,0,150,0,255,0,69,0,0,0,0,0,6,0,0,0,89,0,224,0,91,0,7,0,170,0,0,0,67,0,158,0,59,0,63,0,214,0,187,0,51,0,247,0,108,0,218,0,199,0,0,0,121,0,178,0,130,0,0,0,221,0,169,0,191,0,22,0,96,0,17,0,49,0,81,0,159,0,71,0,175,0,85,0,83,0,0,0,88,0,0,0,108,0,16,0,68,0,12,0,152,0,16,0,162,0,90,0,0,0,35,0,176,0,105,0,47,0,163,0,43,0,42,0,1,0,152,0,92,0,215,0,0,0,0,0,212,0,0,0,94,0,0,0,170,0,0,0,0,0,59,0,161,0,50,0,161,0,227,0,129,0,74,0,220,0,80,0,197,0,174,0,34,0,208,0,175,0,48,0,0,0,217,0,165,0,127,0,92,0,21,0,0,0,160,0,182,0,1,0,0,0,204,0,57,0,66,0,0,0,43,0,72,0,135,0,132,0,0,0,234,0,37,0,136,0,122,0,167,0,231,0,72,0,139,0,80,0,93,0,72,0,151,0,167,0,96,0,165,0,141,0,113,0,218,0,68,0,27,0,43,0,0,0,53,0,113,0,160,0,103,0,0,0,249,0,0,0,3,0,2,0,0,0,119,0,53,0,248,0,0,0,22,0,173,0,72,0,177,0,10,0,0,0,172,0,26,0,94,0,0,0,141,0,200,0,13,0,200,0,0,0,0,0,50,0,124,0,144,0,0,0,203,0,87,0,0,0,230,0,155,0,0,0,199,0,183,0,21,0,12,0,106,0,83,0,192,0,252,0,30,0,0,0,242,0,0,0,212,0,182,0,0,0,85,0,0,0,0,0,58,0,96,0,41,0,210,0,34,0,253,0,0,0,67,0,30,0,38,0,146,0,91,0,17,0,0,0,164,0,0,0,215,0,0,0,188,0,205,0,0,0,97,0,141,0,10,0,39,0,142,0,101,0,0,0,79,0,10,0,77,0,40,0,217,0,73,0,238,0,76,0,169,0,28,0,0,0,128,0,127,0,0,0,87,0,183,0,128,0,248,0,0,0,168,0,187,0,31,0,216,0,10,0,40,0,92,0,254,0,0,0,0,0,27,0,0,0,138,0,184,0,50,0,104,0,17,0,182,0,121,0,75,0,1,0,164,0,28,0,175,0,122,0,0,0,111,0,0,0,114,0,0,0,40,0,187,0,171,0,0,0,50,0,88,0,247,0,184,0,0,0,180,0,0,0,90,0,0,0,243,0,226,0,153,0,214,0,69,0,142,0,19,0,119,0,133,0,58,0,18,0,139,0,54,0,243,0,70,0,197,0,216,0,0,0,194,0,0,0,0,0,94,0,136,0,25,0,115,0,0,0,105,0,223,0,0,0,124,0,154,0,201,0,208,0,255,0,0,0,142,0,111,0,103,0,40,0,232,0,0,0,5,0,38,0,0,0,167,0,157,0,0,0,104,0,64,0,116,0,0,0,255,0,245,0,99,0,211,0,43,0,0,0,0,0,148,0,255,0,16,0,156,0,97,0,0,0,182,0,0,0,97,0,94,0,80,0,230,0,104,0,246,0,210,0,24,0,65,0,165,0,90,0,232,0,168,0,3,0,181,0,0,0,104,0,172,0,234,0,0,0,10,0,161,0,229,0,0,0,37,0,98,0,65,0,151,0,13,0,81,0,152,0,0,0,180,0,10,0,0,0,137,0,53,0,127,0,110,0,26,0,0,0,0,0,0,0,23,0,41,0,210,0,198,0,69,0,58,0,225,0,222,0,162,0,208,0,225,0,173,0,107,0,0,0,0,0,252,0,76,0,0,0,208,0,44,0,249,0,217,0,210,0,243,0,168,0,48,0,9,0,100,0,0,0,0,0,226,0,248,0,106,0,178,0,211,0,92,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (203,31,148,31,63,31,25,31,25,30,76,31,76,30,76,29,194,31,185,31,185,30,185,29,128,31,199,31,167,31,45,31,45,30,203,31,202,31,9,31,78,31,78,30,19,31,95,31,174,31,41,31,215,31,211,31,108,31,108,30,131,31,50,31,36,31,63,31,63,30,209,31,209,30,209,29,253,31,110,31,110,30,56,31,253,31,253,30,253,29,5,31,5,30,5,29,147,31,149,31,211,31,110,31,188,31,65,31,254,31,85,31,85,30,107,31,237,31,44,31,133,31,102,31,102,30,252,31,252,30,24,31,153,31,204,31,18,31,16,31,254,31,1,31,175,31,195,31,149,31,225,31,249,31,141,31,197,31,59,31,59,30,59,29,240,31,8,31,8,30,69,31,69,30,69,29,247,31,116,31,38,31,150,31,255,31,69,31,69,30,69,29,6,31,6,30,89,31,224,31,91,31,7,31,170,31,170,30,67,31,158,31,59,31,63,31,214,31,187,31,51,31,247,31,108,31,218,31,199,31,199,30,121,31,178,31,130,31,130,30,221,31,169,31,191,31,22,31,96,31,17,31,49,31,81,31,159,31,71,31,175,31,85,31,83,31,83,30,88,31,88,30,108,31,16,31,68,31,12,31,152,31,16,31,162,31,90,31,90,30,35,31,176,31,105,31,47,31,163,31,43,31,42,31,1,31,152,31,92,31,215,31,215,30,215,29,212,31,212,30,94,31,94,30,170,31,170,30,170,29,59,31,161,31,50,31,161,31,227,31,129,31,74,31,220,31,80,31,197,31,174,31,34,31,208,31,175,31,48,31,48,30,217,31,165,31,127,31,92,31,21,31,21,30,160,31,182,31,1,31,1,30,204,31,57,31,66,31,66,30,43,31,72,31,135,31,132,31,132,30,234,31,37,31,136,31,122,31,167,31,231,31,72,31,139,31,80,31,93,31,72,31,151,31,167,31,96,31,165,31,141,31,113,31,218,31,68,31,27,31,43,31,43,30,53,31,113,31,160,31,103,31,103,30,249,31,249,30,3,31,2,31,2,30,119,31,53,31,248,31,248,30,22,31,173,31,72,31,177,31,10,31,10,30,172,31,26,31,94,31,94,30,141,31,200,31,13,31,200,31,200,30,200,29,50,31,124,31,144,31,144,30,203,31,87,31,87,30,230,31,155,31,155,30,199,31,183,31,21,31,12,31,106,31,83,31,192,31,252,31,30,31,30,30,242,31,242,30,212,31,182,31,182,30,85,31,85,30,85,29,58,31,96,31,41,31,210,31,34,31,253,31,253,30,67,31,30,31,38,31,146,31,91,31,17,31,17,30,164,31,164,30,215,31,215,30,188,31,205,31,205,30,97,31,141,31,10,31,39,31,142,31,101,31,101,30,79,31,10,31,77,31,40,31,217,31,73,31,238,31,76,31,169,31,28,31,28,30,128,31,127,31,127,30,87,31,183,31,128,31,248,31,248,30,168,31,187,31,31,31,216,31,10,31,40,31,92,31,254,31,254,30,254,29,27,31,27,30,138,31,184,31,50,31,104,31,17,31,182,31,121,31,75,31,1,31,164,31,28,31,175,31,122,31,122,30,111,31,111,30,114,31,114,30,40,31,187,31,171,31,171,30,50,31,88,31,247,31,184,31,184,30,180,31,180,30,90,31,90,30,243,31,226,31,153,31,214,31,69,31,142,31,19,31,119,31,133,31,58,31,18,31,139,31,54,31,243,31,70,31,197,31,216,31,216,30,194,31,194,30,194,29,94,31,136,31,25,31,115,31,115,30,105,31,223,31,223,30,124,31,154,31,201,31,208,31,255,31,255,30,142,31,111,31,103,31,40,31,232,31,232,30,5,31,38,31,38,30,167,31,157,31,157,30,104,31,64,31,116,31,116,30,255,31,245,31,99,31,211,31,43,31,43,30,43,29,148,31,255,31,16,31,156,31,97,31,97,30,182,31,182,30,97,31,94,31,80,31,230,31,104,31,246,31,210,31,24,31,65,31,165,31,90,31,232,31,168,31,3,31,181,31,181,30,104,31,172,31,234,31,234,30,10,31,161,31,229,31,229,30,37,31,98,31,65,31,151,31,13,31,81,31,152,31,152,30,180,31,10,31,10,30,137,31,53,31,127,31,110,31,26,31,26,30,26,29,26,28,23,31,41,31,210,31,198,31,69,31,58,31,225,31,222,31,162,31,208,31,225,31,173,31,107,31,107,30,107,29,252,31,76,31,76,30,208,31,44,31,249,31,217,31,210,31,243,31,168,31,48,31,9,31,100,31,100,30,100,29,226,31,248,31,106,31,178,31,211,31,92,31,92,30,92,29,92,28);

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

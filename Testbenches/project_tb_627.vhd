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

constant SCENARIO_LENGTH : integer := 327;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (31,0,169,0,52,0,254,0,60,0,119,0,177,0,0,0,208,0,218,0,76,0,169,0,205,0,152,0,155,0,83,0,95,0,25,0,194,0,17,0,176,0,0,0,23,0,0,0,0,0,183,0,221,0,233,0,0,0,237,0,47,0,44,0,117,0,23,0,196,0,138,0,143,0,100,0,72,0,36,0,0,0,159,0,8,0,194,0,182,0,196,0,43,0,57,0,251,0,249,0,51,0,0,0,86,0,0,0,68,0,173,0,172,0,85,0,144,0,36,0,0,0,93,0,140,0,164,0,0,0,0,0,0,0,133,0,0,0,188,0,151,0,181,0,184,0,0,0,208,0,197,0,0,0,41,0,205,0,134,0,0,0,145,0,0,0,146,0,88,0,15,0,177,0,248,0,49,0,0,0,131,0,33,0,0,0,201,0,242,0,148,0,132,0,0,0,126,0,220,0,117,0,0,0,0,0,188,0,222,0,0,0,119,0,60,0,0,0,0,0,0,0,121,0,108,0,7,0,149,0,83,0,215,0,139,0,204,0,254,0,193,0,20,0,187,0,226,0,239,0,0,0,66,0,51,0,0,0,24,0,0,0,45,0,23,0,0,0,105,0,23,0,0,0,174,0,143,0,15,0,15,0,7,0,48,0,227,0,244,0,11,0,92,0,0,0,160,0,246,0,25,0,77,0,170,0,0,0,151,0,0,0,165,0,0,0,0,0,138,0,224,0,147,0,0,0,108,0,215,0,84,0,74,0,0,0,67,0,96,0,197,0,214,0,195,0,141,0,0,0,61,0,0,0,181,0,161,0,219,0,0,0,36,0,167,0,0,0,137,0,53,0,158,0,0,0,112,0,224,0,0,0,124,0,0,0,237,0,86,0,105,0,86,0,214,0,36,0,164,0,155,0,91,0,0,0,0,0,108,0,47,0,246,0,152,0,0,0,45,0,246,0,0,0,109,0,39,0,151,0,167,0,111,0,113,0,3,0,67,0,88,0,0,0,195,0,0,0,177,0,103,0,182,0,118,0,56,0,239,0,56,0,0,0,17,0,202,0,164,0,37,0,26,0,148,0,107,0,85,0,0,0,136,0,186,0,189,0,185,0,175,0,0,0,0,0,0,0,129,0,51,0,175,0,0,0,110,0,132,0,0,0,10,0,99,0,204,0,0,0,93,0,0,0,0,0,176,0,192,0,123,0,109,0,183,0,0,0,33,0,249,0,0,0,206,0,135,0,162,0,94,0,0,0,0,0,189,0,170,0,0,0,0,0,199,0,131,0,0,0,183,0,150,0,239,0,152,0,196,0,26,0,96,0,218,0,149,0,209,0,131,0,223,0,7,0,0,0,220,0,0,0,176,0,0,0,206,0,19,0,211,0,229,0,0,0,70,0,247,0,0,0,23,0,129,0,117,0,54,0,144,0,196,0,203,0,243,0,0,0,217,0,233,0,0,0,44,0,131,0,140,0,249,0);
signal scenario_full  : scenario_type := (31,31,169,31,52,31,254,31,60,31,119,31,177,31,177,30,208,31,218,31,76,31,169,31,205,31,152,31,155,31,83,31,95,31,25,31,194,31,17,31,176,31,176,30,23,31,23,30,23,29,183,31,221,31,233,31,233,30,237,31,47,31,44,31,117,31,23,31,196,31,138,31,143,31,100,31,72,31,36,31,36,30,159,31,8,31,194,31,182,31,196,31,43,31,57,31,251,31,249,31,51,31,51,30,86,31,86,30,68,31,173,31,172,31,85,31,144,31,36,31,36,30,93,31,140,31,164,31,164,30,164,29,164,28,133,31,133,30,188,31,151,31,181,31,184,31,184,30,208,31,197,31,197,30,41,31,205,31,134,31,134,30,145,31,145,30,146,31,88,31,15,31,177,31,248,31,49,31,49,30,131,31,33,31,33,30,201,31,242,31,148,31,132,31,132,30,126,31,220,31,117,31,117,30,117,29,188,31,222,31,222,30,119,31,60,31,60,30,60,29,60,28,121,31,108,31,7,31,149,31,83,31,215,31,139,31,204,31,254,31,193,31,20,31,187,31,226,31,239,31,239,30,66,31,51,31,51,30,24,31,24,30,45,31,23,31,23,30,105,31,23,31,23,30,174,31,143,31,15,31,15,31,7,31,48,31,227,31,244,31,11,31,92,31,92,30,160,31,246,31,25,31,77,31,170,31,170,30,151,31,151,30,165,31,165,30,165,29,138,31,224,31,147,31,147,30,108,31,215,31,84,31,74,31,74,30,67,31,96,31,197,31,214,31,195,31,141,31,141,30,61,31,61,30,181,31,161,31,219,31,219,30,36,31,167,31,167,30,137,31,53,31,158,31,158,30,112,31,224,31,224,30,124,31,124,30,237,31,86,31,105,31,86,31,214,31,36,31,164,31,155,31,91,31,91,30,91,29,108,31,47,31,246,31,152,31,152,30,45,31,246,31,246,30,109,31,39,31,151,31,167,31,111,31,113,31,3,31,67,31,88,31,88,30,195,31,195,30,177,31,103,31,182,31,118,31,56,31,239,31,56,31,56,30,17,31,202,31,164,31,37,31,26,31,148,31,107,31,85,31,85,30,136,31,186,31,189,31,185,31,175,31,175,30,175,29,175,28,129,31,51,31,175,31,175,30,110,31,132,31,132,30,10,31,99,31,204,31,204,30,93,31,93,30,93,29,176,31,192,31,123,31,109,31,183,31,183,30,33,31,249,31,249,30,206,31,135,31,162,31,94,31,94,30,94,29,189,31,170,31,170,30,170,29,199,31,131,31,131,30,183,31,150,31,239,31,152,31,196,31,26,31,96,31,218,31,149,31,209,31,131,31,223,31,7,31,7,30,220,31,220,30,176,31,176,30,206,31,19,31,211,31,229,31,229,30,70,31,247,31,247,30,23,31,129,31,117,31,54,31,144,31,196,31,203,31,243,31,243,30,217,31,233,31,233,30,44,31,131,31,140,31,249,31);

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

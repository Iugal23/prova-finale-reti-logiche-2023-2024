-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_684 is
end project_tb_684;

architecture project_tb_arch_684 of project_tb_684 is
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

constant SCENARIO_LENGTH : integer := 392;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (162,0,145,0,249,0,0,0,0,0,0,0,196,0,52,0,161,0,0,0,131,0,0,0,98,0,46,0,114,0,32,0,206,0,57,0,199,0,0,0,0,0,185,0,0,0,0,0,151,0,0,0,139,0,132,0,34,0,0,0,5,0,197,0,0,0,0,0,0,0,167,0,250,0,36,0,229,0,171,0,13,0,114,0,0,0,0,0,0,0,144,0,112,0,2,0,15,0,175,0,15,0,69,0,0,0,0,0,194,0,164,0,0,0,46,0,0,0,133,0,37,0,65,0,50,0,148,0,0,0,248,0,46,0,194,0,140,0,0,0,222,0,203,0,13,0,227,0,162,0,212,0,100,0,0,0,170,0,17,0,211,0,0,0,0,0,113,0,63,0,8,0,0,0,243,0,164,0,4,0,194,0,0,0,0,0,100,0,0,0,238,0,185,0,151,0,164,0,22,0,158,0,175,0,248,0,122,0,174,0,108,0,138,0,115,0,4,0,0,0,33,0,0,0,0,0,0,0,138,0,185,0,144,0,114,0,252,0,117,0,230,0,231,0,139,0,52,0,158,0,41,0,102,0,0,0,58,0,10,0,4,0,187,0,87,0,187,0,133,0,233,0,0,0,0,0,79,0,129,0,0,0,143,0,0,0,221,0,244,0,0,0,0,0,177,0,0,0,221,0,115,0,60,0,69,0,95,0,201,0,118,0,0,0,112,0,120,0,194,0,0,0,80,0,245,0,171,0,231,0,0,0,244,0,215,0,79,0,3,0,199,0,185,0,197,0,127,0,0,0,149,0,251,0,58,0,63,0,27,0,228,0,201,0,140,0,106,0,144,0,52,0,202,0,75,0,182,0,140,0,39,0,239,0,88,0,76,0,6,0,94,0,229,0,0,0,76,0,0,0,243,0,30,0,176,0,229,0,121,0,16,0,212,0,0,0,214,0,85,0,174,0,209,0,174,0,126,0,87,0,0,0,225,0,0,0,206,0,51,0,18,0,32,0,72,0,105,0,18,0,65,0,95,0,0,0,177,0,146,0,239,0,0,0,82,0,167,0,0,0,0,0,241,0,147,0,15,0,177,0,223,0,167,0,172,0,40,0,231,0,0,0,67,0,39,0,0,0,156,0,138,0,102,0,114,0,0,0,181,0,222,0,0,0,77,0,0,0,45,0,0,0,0,0,41,0,145,0,125,0,0,0,228,0,81,0,245,0,176,0,0,0,60,0,216,0,68,0,0,0,1,0,147,0,131,0,68,0,23,0,0,0,5,0,0,0,72,0,0,0,173,0,62,0,53,0,162,0,132,0,5,0,0,0,0,0,0,0,95,0,240,0,109,0,0,0,40,0,116,0,159,0,79,0,108,0,0,0,201,0,70,0,78,0,150,0,27,0,190,0,129,0,204,0,0,0,0,0,0,0,57,0,21,0,211,0,217,0,244,0,54,0,6,0,0,0,147,0,5,0,0,0,97,0,144,0,33,0,64,0,172,0,0,0,173,0,7,0,53,0,108,0,202,0,0,0,111,0,39,0,255,0,1,0,178,0,181,0,21,0,157,0,0,0,40,0,224,0,0,0,202,0,206,0,0,0,38,0,0,0,138,0,15,0,0,0,245,0,113,0,137,0,0,0,108,0,0,0,0,0,58,0,1,0,95,0,48,0,52,0,0,0,0,0,164,0,0,0,188,0,255,0,0,0,0,0,0,0,0,0,167,0,165,0,211,0,2,0,254,0,254,0,153,0,110,0,18,0,26,0,110,0,4,0);
signal scenario_full  : scenario_type := (162,31,145,31,249,31,249,30,249,29,249,28,196,31,52,31,161,31,161,30,131,31,131,30,98,31,46,31,114,31,32,31,206,31,57,31,199,31,199,30,199,29,185,31,185,30,185,29,151,31,151,30,139,31,132,31,34,31,34,30,5,31,197,31,197,30,197,29,197,28,167,31,250,31,36,31,229,31,171,31,13,31,114,31,114,30,114,29,114,28,144,31,112,31,2,31,15,31,175,31,15,31,69,31,69,30,69,29,194,31,164,31,164,30,46,31,46,30,133,31,37,31,65,31,50,31,148,31,148,30,248,31,46,31,194,31,140,31,140,30,222,31,203,31,13,31,227,31,162,31,212,31,100,31,100,30,170,31,17,31,211,31,211,30,211,29,113,31,63,31,8,31,8,30,243,31,164,31,4,31,194,31,194,30,194,29,100,31,100,30,238,31,185,31,151,31,164,31,22,31,158,31,175,31,248,31,122,31,174,31,108,31,138,31,115,31,4,31,4,30,33,31,33,30,33,29,33,28,138,31,185,31,144,31,114,31,252,31,117,31,230,31,231,31,139,31,52,31,158,31,41,31,102,31,102,30,58,31,10,31,4,31,187,31,87,31,187,31,133,31,233,31,233,30,233,29,79,31,129,31,129,30,143,31,143,30,221,31,244,31,244,30,244,29,177,31,177,30,221,31,115,31,60,31,69,31,95,31,201,31,118,31,118,30,112,31,120,31,194,31,194,30,80,31,245,31,171,31,231,31,231,30,244,31,215,31,79,31,3,31,199,31,185,31,197,31,127,31,127,30,149,31,251,31,58,31,63,31,27,31,228,31,201,31,140,31,106,31,144,31,52,31,202,31,75,31,182,31,140,31,39,31,239,31,88,31,76,31,6,31,94,31,229,31,229,30,76,31,76,30,243,31,30,31,176,31,229,31,121,31,16,31,212,31,212,30,214,31,85,31,174,31,209,31,174,31,126,31,87,31,87,30,225,31,225,30,206,31,51,31,18,31,32,31,72,31,105,31,18,31,65,31,95,31,95,30,177,31,146,31,239,31,239,30,82,31,167,31,167,30,167,29,241,31,147,31,15,31,177,31,223,31,167,31,172,31,40,31,231,31,231,30,67,31,39,31,39,30,156,31,138,31,102,31,114,31,114,30,181,31,222,31,222,30,77,31,77,30,45,31,45,30,45,29,41,31,145,31,125,31,125,30,228,31,81,31,245,31,176,31,176,30,60,31,216,31,68,31,68,30,1,31,147,31,131,31,68,31,23,31,23,30,5,31,5,30,72,31,72,30,173,31,62,31,53,31,162,31,132,31,5,31,5,30,5,29,5,28,95,31,240,31,109,31,109,30,40,31,116,31,159,31,79,31,108,31,108,30,201,31,70,31,78,31,150,31,27,31,190,31,129,31,204,31,204,30,204,29,204,28,57,31,21,31,211,31,217,31,244,31,54,31,6,31,6,30,147,31,5,31,5,30,97,31,144,31,33,31,64,31,172,31,172,30,173,31,7,31,53,31,108,31,202,31,202,30,111,31,39,31,255,31,1,31,178,31,181,31,21,31,157,31,157,30,40,31,224,31,224,30,202,31,206,31,206,30,38,31,38,30,138,31,15,31,15,30,245,31,113,31,137,31,137,30,108,31,108,30,108,29,58,31,1,31,95,31,48,31,52,31,52,30,52,29,164,31,164,30,188,31,255,31,255,30,255,29,255,28,255,27,167,31,165,31,211,31,2,31,254,31,254,31,153,31,110,31,18,31,26,31,110,31,4,31);

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

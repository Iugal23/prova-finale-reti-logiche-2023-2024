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

constant SCENARIO_LENGTH : integer := 369;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (205,0,36,0,0,0,250,0,157,0,204,0,172,0,0,0,127,0,216,0,231,0,0,0,214,0,128,0,106,0,181,0,0,0,157,0,104,0,0,0,167,0,63,0,233,0,164,0,146,0,170,0,200,0,145,0,66,0,70,0,97,0,250,0,145,0,75,0,0,0,227,0,67,0,0,0,101,0,30,0,135,0,0,0,148,0,0,0,236,0,0,0,40,0,131,0,177,0,198,0,102,0,92,0,183,0,145,0,232,0,82,0,146,0,91,0,82,0,70,0,249,0,240,0,224,0,0,0,179,0,97,0,0,0,120,0,30,0,0,0,114,0,145,0,0,0,252,0,110,0,187,0,206,0,0,0,129,0,154,0,214,0,214,0,0,0,210,0,53,0,227,0,0,0,148,0,113,0,0,0,140,0,0,0,59,0,120,0,76,0,32,0,0,0,226,0,72,0,0,0,0,0,197,0,197,0,0,0,75,0,119,0,155,0,108,0,181,0,141,0,141,0,8,0,82,0,0,0,83,0,180,0,110,0,24,0,96,0,0,0,200,0,15,0,162,0,0,0,10,0,143,0,88,0,0,0,185,0,35,0,0,0,204,0,246,0,237,0,0,0,187,0,212,0,127,0,91,0,182,0,201,0,222,0,91,0,0,0,34,0,40,0,0,0,46,0,164,0,0,0,121,0,0,0,6,0,4,0,0,0,22,0,104,0,10,0,196,0,254,0,0,0,182,0,109,0,61,0,119,0,185,0,123,0,38,0,78,0,0,0,20,0,46,0,103,0,63,0,136,0,175,0,172,0,122,0,0,0,162,0,3,0,0,0,0,0,81,0,0,0,87,0,210,0,0,0,0,0,69,0,201,0,32,0,30,0,188,0,7,0,146,0,115,0,35,0,66,0,193,0,11,0,103,0,5,0,57,0,180,0,82,0,0,0,116,0,58,0,101,0,0,0,224,0,0,0,41,0,0,0,128,0,183,0,62,0,114,0,0,0,117,0,217,0,237,0,58,0,119,0,0,0,233,0,32,0,0,0,0,0,0,0,0,0,225,0,61,0,50,0,0,0,15,0,60,0,233,0,188,0,60,0,176,0,0,0,198,0,249,0,0,0,0,0,28,0,138,0,103,0,175,0,0,0,0,0,207,0,134,0,234,0,9,0,153,0,205,0,63,0,27,0,255,0,0,0,233,0,0,0,33,0,0,0,206,0,224,0,121,0,222,0,227,0,0,0,123,0,52,0,49,0,90,0,182,0,152,0,201,0,60,0,0,0,0,0,45,0,51,0,0,0,231,0,3,0,253,0,137,0,167,0,191,0,0,0,145,0,0,0,222,0,146,0,5,0,0,0,0,0,242,0,0,0,154,0,3,0,225,0,178,0,203,0,44,0,7,0,0,0,116,0,2,0,152,0,18,0,28,0,172,0,168,0,224,0,8,0,235,0,171,0,125,0,0,0,4,0,150,0,12,0,0,0,215,0,64,0,0,0,17,0,88,0,18,0,173,0,234,0,76,0,110,0,119,0,251,0,230,0,36,0,133,0,131,0,101,0,140,0,243,0,147,0,164,0,0,0,0,0,255,0,180,0,46,0,188,0,225,0,135,0,241,0,24,0,164,0,203,0,230,0,0,0,0,0,147,0,223,0,155,0,119,0,202,0,97,0);
signal scenario_full  : scenario_type := (205,31,36,31,36,30,250,31,157,31,204,31,172,31,172,30,127,31,216,31,231,31,231,30,214,31,128,31,106,31,181,31,181,30,157,31,104,31,104,30,167,31,63,31,233,31,164,31,146,31,170,31,200,31,145,31,66,31,70,31,97,31,250,31,145,31,75,31,75,30,227,31,67,31,67,30,101,31,30,31,135,31,135,30,148,31,148,30,236,31,236,30,40,31,131,31,177,31,198,31,102,31,92,31,183,31,145,31,232,31,82,31,146,31,91,31,82,31,70,31,249,31,240,31,224,31,224,30,179,31,97,31,97,30,120,31,30,31,30,30,114,31,145,31,145,30,252,31,110,31,187,31,206,31,206,30,129,31,154,31,214,31,214,31,214,30,210,31,53,31,227,31,227,30,148,31,113,31,113,30,140,31,140,30,59,31,120,31,76,31,32,31,32,30,226,31,72,31,72,30,72,29,197,31,197,31,197,30,75,31,119,31,155,31,108,31,181,31,141,31,141,31,8,31,82,31,82,30,83,31,180,31,110,31,24,31,96,31,96,30,200,31,15,31,162,31,162,30,10,31,143,31,88,31,88,30,185,31,35,31,35,30,204,31,246,31,237,31,237,30,187,31,212,31,127,31,91,31,182,31,201,31,222,31,91,31,91,30,34,31,40,31,40,30,46,31,164,31,164,30,121,31,121,30,6,31,4,31,4,30,22,31,104,31,10,31,196,31,254,31,254,30,182,31,109,31,61,31,119,31,185,31,123,31,38,31,78,31,78,30,20,31,46,31,103,31,63,31,136,31,175,31,172,31,122,31,122,30,162,31,3,31,3,30,3,29,81,31,81,30,87,31,210,31,210,30,210,29,69,31,201,31,32,31,30,31,188,31,7,31,146,31,115,31,35,31,66,31,193,31,11,31,103,31,5,31,57,31,180,31,82,31,82,30,116,31,58,31,101,31,101,30,224,31,224,30,41,31,41,30,128,31,183,31,62,31,114,31,114,30,117,31,217,31,237,31,58,31,119,31,119,30,233,31,32,31,32,30,32,29,32,28,32,27,225,31,61,31,50,31,50,30,15,31,60,31,233,31,188,31,60,31,176,31,176,30,198,31,249,31,249,30,249,29,28,31,138,31,103,31,175,31,175,30,175,29,207,31,134,31,234,31,9,31,153,31,205,31,63,31,27,31,255,31,255,30,233,31,233,30,33,31,33,30,206,31,224,31,121,31,222,31,227,31,227,30,123,31,52,31,49,31,90,31,182,31,152,31,201,31,60,31,60,30,60,29,45,31,51,31,51,30,231,31,3,31,253,31,137,31,167,31,191,31,191,30,145,31,145,30,222,31,146,31,5,31,5,30,5,29,242,31,242,30,154,31,3,31,225,31,178,31,203,31,44,31,7,31,7,30,116,31,2,31,152,31,18,31,28,31,172,31,168,31,224,31,8,31,235,31,171,31,125,31,125,30,4,31,150,31,12,31,12,30,215,31,64,31,64,30,17,31,88,31,18,31,173,31,234,31,76,31,110,31,119,31,251,31,230,31,36,31,133,31,131,31,101,31,140,31,243,31,147,31,164,31,164,30,164,29,255,31,180,31,46,31,188,31,225,31,135,31,241,31,24,31,164,31,203,31,230,31,230,30,230,29,147,31,223,31,155,31,119,31,202,31,97,31);

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

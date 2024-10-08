-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_20 is
end project_tb_20;

architecture project_tb_arch_20 of project_tb_20 is
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

constant SCENARIO_LENGTH : integer := 387;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (90,0,0,0,100,0,35,0,60,0,54,0,80,0,0,0,192,0,12,0,117,0,44,0,121,0,148,0,228,0,0,0,185,0,0,0,221,0,87,0,0,0,29,0,37,0,60,0,0,0,0,0,32,0,0,0,0,0,40,0,244,0,89,0,43,0,0,0,188,0,16,0,0,0,0,0,71,0,70,0,70,0,161,0,163,0,203,0,79,0,237,0,160,0,249,0,0,0,0,0,9,0,154,0,210,0,55,0,160,0,14,0,217,0,0,0,183,0,0,0,22,0,102,0,204,0,0,0,42,0,51,0,167,0,0,0,62,0,182,0,165,0,117,0,213,0,122,0,220,0,0,0,191,0,180,0,34,0,29,0,128,0,72,0,102,0,219,0,114,0,102,0,73,0,0,0,149,0,53,0,36,0,144,0,18,0,69,0,17,0,95,0,189,0,0,0,204,0,0,0,220,0,161,0,113,0,137,0,0,0,239,0,96,0,55,0,0,0,38,0,179,0,80,0,5,0,0,0,50,0,0,0,135,0,124,0,200,0,0,0,138,0,0,0,9,0,156,0,0,0,237,0,41,0,0,0,174,0,21,0,0,0,239,0,58,0,249,0,203,0,110,0,0,0,0,0,154,0,188,0,0,0,31,0,38,0,5,0,146,0,249,0,53,0,48,0,184,0,156,0,156,0,30,0,0,0,174,0,95,0,0,0,0,0,206,0,41,0,126,0,181,0,105,0,55,0,216,0,176,0,152,0,162,0,236,0,0,0,0,0,176,0,0,0,116,0,91,0,160,0,236,0,0,0,159,0,66,0,168,0,79,0,24,0,99,0,0,0,0,0,174,0,0,0,42,0,132,0,75,0,0,0,111,0,98,0,81,0,7,0,0,0,233,0,0,0,86,0,244,0,26,0,6,0,0,0,177,0,170,0,148,0,0,0,229,0,165,0,247,0,52,0,39,0,210,0,222,0,124,0,34,0,0,0,96,0,234,0,78,0,107,0,0,0,18,0,150,0,27,0,168,0,51,0,168,0,248,0,120,0,198,0,198,0,149,0,112,0,20,0,241,0,20,0,173,0,136,0,196,0,194,0,37,0,52,0,207,0,0,0,108,0,19,0,180,0,43,0,95,0,0,0,231,0,25,0,0,0,49,0,0,0,0,0,237,0,192,0,0,0,0,0,44,0,244,0,0,0,101,0,174,0,0,0,197,0,54,0,0,0,186,0,77,0,85,0,0,0,0,0,0,0,15,0,158,0,0,0,203,0,0,0,20,0,214,0,40,0,169,0,213,0,135,0,13,0,106,0,34,0,106,0,126,0,72,0,3,0,146,0,57,0,49,0,32,0,177,0,0,0,137,0,222,0,45,0,87,0,250,0,65,0,0,0,0,0,78,0,0,0,78,0,0,0,16,0,28,0,0,0,0,0,152,0,156,0,188,0,201,0,0,0,62,0,86,0,175,0,0,0,67,0,69,0,242,0,0,0,164,0,189,0,0,0,0,0,160,0,82,0,114,0,64,0,144,0,234,0,124,0,167,0,92,0,207,0,236,0,51,0,8,0,217,0,90,0,0,0,140,0,94,0,62,0,145,0,138,0,211,0,231,0,186,0,0,0,157,0,78,0,129,0,57,0,54,0,124,0,247,0,160,0,165,0,200,0,223,0,57,0,226,0,132,0,204,0,226,0,166,0,130,0,0,0,0,0,61,0,0,0,85,0,178,0,0,0,32,0,45,0,26,0,135,0);
signal scenario_full  : scenario_type := (90,31,90,30,100,31,35,31,60,31,54,31,80,31,80,30,192,31,12,31,117,31,44,31,121,31,148,31,228,31,228,30,185,31,185,30,221,31,87,31,87,30,29,31,37,31,60,31,60,30,60,29,32,31,32,30,32,29,40,31,244,31,89,31,43,31,43,30,188,31,16,31,16,30,16,29,71,31,70,31,70,31,161,31,163,31,203,31,79,31,237,31,160,31,249,31,249,30,249,29,9,31,154,31,210,31,55,31,160,31,14,31,217,31,217,30,183,31,183,30,22,31,102,31,204,31,204,30,42,31,51,31,167,31,167,30,62,31,182,31,165,31,117,31,213,31,122,31,220,31,220,30,191,31,180,31,34,31,29,31,128,31,72,31,102,31,219,31,114,31,102,31,73,31,73,30,149,31,53,31,36,31,144,31,18,31,69,31,17,31,95,31,189,31,189,30,204,31,204,30,220,31,161,31,113,31,137,31,137,30,239,31,96,31,55,31,55,30,38,31,179,31,80,31,5,31,5,30,50,31,50,30,135,31,124,31,200,31,200,30,138,31,138,30,9,31,156,31,156,30,237,31,41,31,41,30,174,31,21,31,21,30,239,31,58,31,249,31,203,31,110,31,110,30,110,29,154,31,188,31,188,30,31,31,38,31,5,31,146,31,249,31,53,31,48,31,184,31,156,31,156,31,30,31,30,30,174,31,95,31,95,30,95,29,206,31,41,31,126,31,181,31,105,31,55,31,216,31,176,31,152,31,162,31,236,31,236,30,236,29,176,31,176,30,116,31,91,31,160,31,236,31,236,30,159,31,66,31,168,31,79,31,24,31,99,31,99,30,99,29,174,31,174,30,42,31,132,31,75,31,75,30,111,31,98,31,81,31,7,31,7,30,233,31,233,30,86,31,244,31,26,31,6,31,6,30,177,31,170,31,148,31,148,30,229,31,165,31,247,31,52,31,39,31,210,31,222,31,124,31,34,31,34,30,96,31,234,31,78,31,107,31,107,30,18,31,150,31,27,31,168,31,51,31,168,31,248,31,120,31,198,31,198,31,149,31,112,31,20,31,241,31,20,31,173,31,136,31,196,31,194,31,37,31,52,31,207,31,207,30,108,31,19,31,180,31,43,31,95,31,95,30,231,31,25,31,25,30,49,31,49,30,49,29,237,31,192,31,192,30,192,29,44,31,244,31,244,30,101,31,174,31,174,30,197,31,54,31,54,30,186,31,77,31,85,31,85,30,85,29,85,28,15,31,158,31,158,30,203,31,203,30,20,31,214,31,40,31,169,31,213,31,135,31,13,31,106,31,34,31,106,31,126,31,72,31,3,31,146,31,57,31,49,31,32,31,177,31,177,30,137,31,222,31,45,31,87,31,250,31,65,31,65,30,65,29,78,31,78,30,78,31,78,30,16,31,28,31,28,30,28,29,152,31,156,31,188,31,201,31,201,30,62,31,86,31,175,31,175,30,67,31,69,31,242,31,242,30,164,31,189,31,189,30,189,29,160,31,82,31,114,31,64,31,144,31,234,31,124,31,167,31,92,31,207,31,236,31,51,31,8,31,217,31,90,31,90,30,140,31,94,31,62,31,145,31,138,31,211,31,231,31,186,31,186,30,157,31,78,31,129,31,57,31,54,31,124,31,247,31,160,31,165,31,200,31,223,31,57,31,226,31,132,31,204,31,226,31,166,31,130,31,130,30,130,29,61,31,61,30,85,31,178,31,178,30,32,31,45,31,26,31,135,31);

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

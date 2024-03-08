-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_727 is
end project_tb_727;

architecture project_tb_arch_727 of project_tb_727 is
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

constant SCENARIO_LENGTH : integer := 492;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (131,0,111,0,249,0,11,0,224,0,230,0,0,0,0,0,89,0,225,0,98,0,0,0,1,0,154,0,87,0,171,0,167,0,207,0,143,0,101,0,83,0,92,0,164,0,225,0,24,0,0,0,133,0,172,0,0,0,104,0,0,0,0,0,44,0,163,0,0,0,11,0,16,0,194,0,211,0,219,0,125,0,245,0,94,0,41,0,0,0,0,0,143,0,225,0,10,0,0,0,0,0,165,0,0,0,207,0,201,0,0,0,0,0,174,0,95,0,205,0,84,0,217,0,61,0,78,0,100,0,233,0,140,0,171,0,99,0,132,0,89,0,0,0,148,0,112,0,242,0,253,0,0,0,0,0,191,0,247,0,30,0,138,0,99,0,238,0,121,0,69,0,245,0,132,0,143,0,207,0,20,0,192,0,223,0,65,0,249,0,173,0,28,0,149,0,0,0,34,0,12,0,177,0,190,0,201,0,89,0,162,0,0,0,72,0,130,0,118,0,0,0,127,0,207,0,0,0,0,0,189,0,9,0,0,0,234,0,82,0,236,0,90,0,8,0,164,0,135,0,67,0,95,0,43,0,0,0,241,0,0,0,103,0,118,0,157,0,186,0,152,0,187,0,95,0,244,0,188,0,128,0,59,0,238,0,48,0,168,0,135,0,243,0,59,0,0,0,102,0,1,0,0,0,196,0,219,0,149,0,5,0,17,0,245,0,114,0,3,0,193,0,27,0,153,0,0,0,192,0,107,0,87,0,21,0,31,0,166,0,19,0,33,0,20,0,0,0,80,0,63,0,211,0,241,0,0,0,0,0,0,0,0,0,73,0,109,0,101,0,106,0,208,0,216,0,57,0,205,0,42,0,77,0,89,0,75,0,131,0,118,0,132,0,254,0,0,0,6,0,14,0,214,0,0,0,46,0,193,0,181,0,184,0,0,0,95,0,55,0,201,0,0,0,67,0,155,0,104,0,0,0,159,0,92,0,243,0,125,0,0,0,0,0,8,0,53,0,254,0,0,0,107,0,85,0,242,0,0,0,209,0,43,0,118,0,121,0,106,0,0,0,12,0,38,0,87,0,0,0,47,0,255,0,134,0,0,0,102,0,0,0,182,0,95,0,6,0,125,0,191,0,209,0,45,0,207,0,0,0,162,0,141,0,0,0,80,0,85,0,186,0,0,0,9,0,0,0,180,0,222,0,77,0,198,0,184,0,34,0,0,0,201,0,212,0,175,0,26,0,160,0,109,0,0,0,64,0,0,0,64,0,231,0,0,0,169,0,138,0,101,0,9,0,0,0,85,0,232,0,44,0,218,0,0,0,205,0,226,0,170,0,42,0,0,0,150,0,85,0,0,0,81,0,63,0,68,0,111,0,90,0,127,0,46,0,1,0,62,0,0,0,254,0,58,0,0,0,21,0,75,0,168,0,161,0,200,0,109,0,182,0,0,0,0,0,155,0,21,0,0,0,0,0,80,0,203,0,210,0,91,0,41,0,237,0,99,0,198,0,66,0,0,0,22,0,175,0,53,0,140,0,126,0,156,0,0,0,0,0,158,0,42,0,210,0,67,0,35,0,63,0,59,0,202,0,209,0,0,0,159,0,2,0,157,0,33,0,19,0,0,0,25,0,21,0,221,0,0,0,0,0,229,0,0,0,0,0,104,0,150,0,98,0,0,0,0,0,81,0,129,0,198,0,171,0,184,0,167,0,183,0,17,0,0,0,250,0,228,0,210,0,215,0,112,0,212,0,225,0,77,0,66,0,219,0,124,0,177,0,33,0,186,0,69,0,154,0,27,0,48,0,75,0,34,0,23,0,39,0,0,0,36,0,243,0,137,0,239,0,202,0,231,0,102,0,170,0,0,0,0,0,0,0,176,0,0,0,1,0,181,0,6,0,188,0,0,0,198,0,99,0,38,0,171,0,0,0,149,0,162,0,105,0,125,0,0,0,8,0,208,0,238,0,104,0,195,0,214,0,57,0,242,0,201,0,0,0,186,0,35,0,248,0,0,0,14,0,96,0,149,0,0,0,111,0,150,0,116,0,0,0,216,0,165,0,165,0,0,0,244,0,176,0,51,0,134,0,119,0,101,0,228,0,5,0,130,0,21,0,0,0,184,0,0,0,0,0,31,0,141,0,0,0,26,0,245,0,0,0,0,0,140,0,237,0,162,0,0,0,0,0,2,0,75,0,226,0,35,0,206,0,0,0);
signal scenario_full  : scenario_type := (131,31,111,31,249,31,11,31,224,31,230,31,230,30,230,29,89,31,225,31,98,31,98,30,1,31,154,31,87,31,171,31,167,31,207,31,143,31,101,31,83,31,92,31,164,31,225,31,24,31,24,30,133,31,172,31,172,30,104,31,104,30,104,29,44,31,163,31,163,30,11,31,16,31,194,31,211,31,219,31,125,31,245,31,94,31,41,31,41,30,41,29,143,31,225,31,10,31,10,30,10,29,165,31,165,30,207,31,201,31,201,30,201,29,174,31,95,31,205,31,84,31,217,31,61,31,78,31,100,31,233,31,140,31,171,31,99,31,132,31,89,31,89,30,148,31,112,31,242,31,253,31,253,30,253,29,191,31,247,31,30,31,138,31,99,31,238,31,121,31,69,31,245,31,132,31,143,31,207,31,20,31,192,31,223,31,65,31,249,31,173,31,28,31,149,31,149,30,34,31,12,31,177,31,190,31,201,31,89,31,162,31,162,30,72,31,130,31,118,31,118,30,127,31,207,31,207,30,207,29,189,31,9,31,9,30,234,31,82,31,236,31,90,31,8,31,164,31,135,31,67,31,95,31,43,31,43,30,241,31,241,30,103,31,118,31,157,31,186,31,152,31,187,31,95,31,244,31,188,31,128,31,59,31,238,31,48,31,168,31,135,31,243,31,59,31,59,30,102,31,1,31,1,30,196,31,219,31,149,31,5,31,17,31,245,31,114,31,3,31,193,31,27,31,153,31,153,30,192,31,107,31,87,31,21,31,31,31,166,31,19,31,33,31,20,31,20,30,80,31,63,31,211,31,241,31,241,30,241,29,241,28,241,27,73,31,109,31,101,31,106,31,208,31,216,31,57,31,205,31,42,31,77,31,89,31,75,31,131,31,118,31,132,31,254,31,254,30,6,31,14,31,214,31,214,30,46,31,193,31,181,31,184,31,184,30,95,31,55,31,201,31,201,30,67,31,155,31,104,31,104,30,159,31,92,31,243,31,125,31,125,30,125,29,8,31,53,31,254,31,254,30,107,31,85,31,242,31,242,30,209,31,43,31,118,31,121,31,106,31,106,30,12,31,38,31,87,31,87,30,47,31,255,31,134,31,134,30,102,31,102,30,182,31,95,31,6,31,125,31,191,31,209,31,45,31,207,31,207,30,162,31,141,31,141,30,80,31,85,31,186,31,186,30,9,31,9,30,180,31,222,31,77,31,198,31,184,31,34,31,34,30,201,31,212,31,175,31,26,31,160,31,109,31,109,30,64,31,64,30,64,31,231,31,231,30,169,31,138,31,101,31,9,31,9,30,85,31,232,31,44,31,218,31,218,30,205,31,226,31,170,31,42,31,42,30,150,31,85,31,85,30,81,31,63,31,68,31,111,31,90,31,127,31,46,31,1,31,62,31,62,30,254,31,58,31,58,30,21,31,75,31,168,31,161,31,200,31,109,31,182,31,182,30,182,29,155,31,21,31,21,30,21,29,80,31,203,31,210,31,91,31,41,31,237,31,99,31,198,31,66,31,66,30,22,31,175,31,53,31,140,31,126,31,156,31,156,30,156,29,158,31,42,31,210,31,67,31,35,31,63,31,59,31,202,31,209,31,209,30,159,31,2,31,157,31,33,31,19,31,19,30,25,31,21,31,221,31,221,30,221,29,229,31,229,30,229,29,104,31,150,31,98,31,98,30,98,29,81,31,129,31,198,31,171,31,184,31,167,31,183,31,17,31,17,30,250,31,228,31,210,31,215,31,112,31,212,31,225,31,77,31,66,31,219,31,124,31,177,31,33,31,186,31,69,31,154,31,27,31,48,31,75,31,34,31,23,31,39,31,39,30,36,31,243,31,137,31,239,31,202,31,231,31,102,31,170,31,170,30,170,29,170,28,176,31,176,30,1,31,181,31,6,31,188,31,188,30,198,31,99,31,38,31,171,31,171,30,149,31,162,31,105,31,125,31,125,30,8,31,208,31,238,31,104,31,195,31,214,31,57,31,242,31,201,31,201,30,186,31,35,31,248,31,248,30,14,31,96,31,149,31,149,30,111,31,150,31,116,31,116,30,216,31,165,31,165,31,165,30,244,31,176,31,51,31,134,31,119,31,101,31,228,31,5,31,130,31,21,31,21,30,184,31,184,30,184,29,31,31,141,31,141,30,26,31,245,31,245,30,245,29,140,31,237,31,162,31,162,30,162,29,2,31,75,31,226,31,35,31,206,31,206,30);

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
